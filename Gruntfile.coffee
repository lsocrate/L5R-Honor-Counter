module.exports = (grunt) ->
  # Config
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    coffee:
      dev:
        files:
          'js/main.js':'/tmp/grunt/<%= pkg.name %>/coffee/script.coffee'
      prod:
        files:
          '/tmp/grunt/<%= pkg.name %>/js/main.js':'/tmp/grunt/<%= pkg.name %>/coffee/script.coffee'
    uglify:
      prod:
        src: '/tmp/grunt/<%= pkg.name %>/js/main.js'
        dest: 'js/main.js'
    watch:
      js:
        files: 'src/*.coffee'
        tasks: ['concat:coffee', 'coffee:dev']
        options:
          interrupt: true
      css:
        files: 'sass/*'
        tasks: ['sass:dev', 'concat:css']
        options:
          interrupt: true
    compress:
      package:
        options:
          archive: 'builds/<%= pkg.name %>-<%= pkg.version %>.zip'
        files: [
          {src:['*.html', '*.txt', 'css/**', 'js/**']}
        ]
    sass:
      dev:
        options:
          style: 'nested'
          compass: true
        files:
          '/tmp/grunt/<%= pkg.name %>/css/main.css': 'sass/style.sass'
      prod:
        options:
          style: 'compressed'
          compass: true
        files:
          '/tmp/grunt/<%= pkg.name %>/css/main.css': 'sass/style.sass'
    concat:
      css:
        src: ['/tmp/grunt/<%= pkg.name %>/css/main.css']
        dest: 'css/styles.css'
      coffee:
        src: [
          'src/player.coffee'
          'src/honor-counter.coffee'
          'src/main.coffee'
        ]
        dest: '/tmp/grunt/<%= pkg.name %>/coffee/script.coffee'
    manifest:
      dev:
        options:
          basePath: './'
          timestamp: true
        src: []
        dest: 'manifest.appcache'
      prod:
        options:
          basePath: './'
          timestamp: true
        src: [
          '*.html'
          'js/*.js'
          'css/*.css'
          'img/*'
          'fonts/*'
        ]
        dest: 'manifest.appcache'
    img:
      assets:
        src: 'img'
      icons:
        src: '*.png'

    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-compress')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-manifest')
    grunt.loadNpmTasks('grunt-img')

    grunt.registerTask('dev', 'Development environment', ->
      grunt.task.run([
        'concat:coffee'
        'coffee:dev'
        'sass:dev'
        'concat:css'
        'manifest:dev'
        'watch'
      ])
    )
    grunt.registerTask('prod', 'Production environment', ->
      grunt.task.run([
        'concat:coffee'
        'coffee:prod'
        'uglify:prod'
        'sass:prod'
        'concat:css'
        'manifest:prod'
      ])
    )
    grunt.registerTask('package', 'Make deployment package', ->
      grunt.task.run(['prod', 'compress:package'])
    )
  )
