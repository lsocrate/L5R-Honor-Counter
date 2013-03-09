module.exports = (grunt) ->
  # Config
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    coffee:
      compile:
        files:
          '/tmp/grunt/<%= pkg.name %>/js/main.js':'src/main.coffee'
    uglify:
      js:
        src: '/tmp/grunt/<%= pkg.name %>/js/main.js'
        dest: 'js/main.js'
    copy:
      main:
        files: [
          {expand: true, cwd: '/tmp/grunt/<%= pkg.name %>/js/', src: '*', dest: 'js/', filter: 'isFile'}
        ]
    watch:
      js:
        files: 'src/*.coffee'
        tasks: ['clean', 'coffee', 'copy']
        options:
          interrupt: true
      css:
        files: 'sass/*'
        tasks: ['sass:css', 'concat:css']
        options:
          interrupt: true
    clean: ["js"]
    compress:
      package:
        options:
          archive: 'builds/<%= pkg.name %>-<%= pkg.version %>.zip'
        files: [
          {src:['*.html', '*.txt', 'css/**', 'js/**', 'libs/**']}
        ]
    sass:
      css:
        options:
          style: 'compressed'
          compass: true
        files:
          '/tmp/grunt/<%= pkg.name %>/css/main.css': 'sass/style.sass'
          '/tmp/grunt/<%= pkg.name %>/css/basis.css': [
            'sass/normalize.scss'
            'sass/main.scss'
          ]
    concat:
      css:
        options:
          separator: ';'
        src: [
          '/tmp/grunt/<%= pkg.name %>/css/basis.css'
          '/tmp/grunt/<%= pkg.name %>/css/main.css'
        ]
        dest: 'css/styles.css'
    manifest:
      generate:
        options:
          basePath: './'
          timestamp: true
        src: [
          '*.html'
          'libs/*.js'
          'js/*.js'
          'css/*.css'
        ]
        dest: 'manifest.appcache'

    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-contrib-compress')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-manifest')

    grunt.registerTask('dev', 'Development environment', ->
      grunt.task.run(['clean', 'coffee', 'sass', 'concat', 'copy', 'watch'])
    )
    grunt.registerTask('prod', 'Production environment', ->
      grunt.task.run(['clean', 'coffee', 'sass', 'concat', 'uglify', 'manifest'])
    )
    grunt.registerTask('package', 'Make deployment package', ->
      grunt.task.run(['prod', 'compress:package'])
    )
  )
