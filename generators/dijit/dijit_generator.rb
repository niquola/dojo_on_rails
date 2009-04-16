class DijitGenerator < Rails::Generator::Base
  #include module to generate test page
  include Dojo::ViewHelpers
  #workaraund to force dojo helper work
  def params
    {}
  end

  def help_message
    %Q[
    Usage: script/generate dijit CLASSNAME [OPTS] [BASENAME] [MIXIN1,MIXIN2...]

    generate custom dijit widget

    Options:

        CLASSNAME - name of dijit. There are could be diferent types of package name resolution:
          * just name (MyWidget) - the package will be taken from dojo.yml config (default_package)
          * dot started name (.subModule.MyWidget) -  default package will be added to begining
          * full name (some.new.module.MyWidget) -  declared package will be used
        OPTS - is abbriviation string example - tBM
           downcase means turn on flag, upper - off
           x   - just placeholder do not change defaults
           t/T - generate template
           w/W - widgets in template
           b/B - append base class
           m/M - append mixins
           p/P - do generate test page
           c/C - do generate css for widget
           f/F - open in firefox

           defaults can be changed in dojo.yml

        BASENAME and MIXINs - names of base class and mixins (the same package resolution used as with CLASSNAME)

    Example: script/generate dijit .layout.AppContainer MP dijit.layout._ContainerWidget  .layout._ContainerMixin  kley.mvc.MediatorMixin

    ]
  end
  #return value if not nil else default_value
  def ifnil?(val,default_value)
    (val.nil? )?  default_value : val
  end
  def parse_config
    cfg=DojoConfig.generators.dijit 
    @default_package=ifnil?(cfg['default_package'], 'app.views')
    @base_class=ifnil?(cfg['base_class'] , 'dijit._Widget')
    @templated=ifnil?(cfg['templated'],true)
    @mixins=ifnil?(cfg['mixins'] , ['dijit._Templated'] )
    @generate_test_page=ifnil?( cfg['generate_test_page'] , true)
    @generate_css=ifnil?( cfg['generate_css'] , true)
    @widgets_in_template =ifnil?(cfg['widgets_in_template'] , false)
    @open_in_firefox=ifnil?(cfg['open_in_firefox'] , true)

    @default_package=ifnil?(cfg['default_package'],'app.views')
  end
  def o?(flag,on_val,off_val,default_value)
    unless @opts.index(flag).nil?
      return on_val
    end
    unless @opts.index(flag.upcase).nil?
      return off_val
    end
    default_value
  end
  def parse_opts(opts)
    @opts= opts
    @base_class=o?('b',@base_class,'null',@base_class)
    @templated= o?('t',true,false,@templated) 
    @mixins=o?('m',@mixins,[],@mixins)
    @generate_test_page=o?('p',true,false,@generate_test_page)
    @generate_css=o?('c', true,false,@generate_css)
    @widgets_in_template =o?('w', true,false,@widgets_in_template)
    @open_in_firefox=o?('f',true,false,@open_in_firefox)
  end
  def expand_name(full_name)
    case full_name
    when  /^\./ :
      full_name=@default_package + full_name
    when  /\./ :
    else 
      full_name=@default_package + '.' + full_name
    end
    full_name
  end
  def manifest
    record do |m|
      unless args.size > 0
        puts help_message
        exit
      end 
      #parse dojo.yml config
      parse_config

      #full_name
      @full_name=expand_name args.shift


      #parse opts
      unless args[0].nil?
        parse_opts(args.shift)
      end
      #base class if given
      unless args[0].nil?
        @base_class=expand_name args.shift  
      end
      #mixins if given
      if args.size > 0
        args.map {|mixin| expand_name mixin}
      end
      
      
      packages = @full_name.split('.')
      
      # construct names
      @class_name = packages.delete_at(-1)
      @package_name = packages.join('.')
      @no_dots_name=packages.inject(''){|name,pak| name + pak.capitalize} + @class_name 

      #construct pathes
      @package_path = packages.inject(File.join(DojoConfig.root,'src')){|path,pak| File.join(path,pak)} 
      @root_package_path = File.join(DojoConfig.root,'src',packages[0])
      @template_path=File.join(@package_path,'templates')
      @css_path=File.join(@root_package_path,'themes',DojoConfig.dojo.theme,'views')
      @test_path=File.join(@root_package_path,'tests')

      # create all dir if not exists
      [@package_path,@template_path,@css_path,@test_path].each do |dir|
        m.directory dir
      end

      assigns={
        :full_name=>@full_name,
        :package_name=>@package_name,
        :no_dots_name=>@no_dots_name,
        :class_name=>@class_name,
        :creator=>DojoConfig.generators.author,
        :mixins=>@mixins,
        :base_class=>@base_class,
        :is_templated=>@templated,
        :dojo_helper_content=> dojo(:app=>'test'),
        :widgets_in_template=>@widgets_in_template
      }
      m.template "dijit.js", File.join(@package_path,"#{@class_name}.js"), :assigns=>assigns
      m.template "dijit.html",File.join(@template_path, "#{@class_name}.html"), :assigns=>assigns if @templated
      m.template "dijit.css", File.join(@css_path, "#{@no_dots_name}.css"), :assigns=>assigns if @generate_css 
      m.template "test.html", File.join(@test_path,"#{@no_dots_name}.html"),:assigns=>assigns if @generate_test_page

      test_url= "#{DojoConfig.baseUrl}#{@test_path.gsub(/^public/,'')}/#{@no_dots_name}.html"
      puts "Open firefox to inspect test page #{test_url}"
      #TODO open firefox only on creation - not when destroy
      `firefox --new-tab #{test_url} &`  if @open_in_firefox
    end
  rescue Exception => e
    puts e.backtrace
  end
end
