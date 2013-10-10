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
        files: 'less/*'
        tasks: ['less:dev']
        options:
          interrupt: true
    compress:
      package:
        options:
          archive: 'builds/<%= pkg.name %>-<%= pkg.version %>.zip'
        files: [
          {src:['*.html', '*.txt', 'css/**', 'js/**']}
        ]
    less:
      dev:
        files:
          'css/styles.css': 'less/style.less'
      prod:
        options:
          compress: true
          yuicompress: true
        files:
          'css/styles.css': 'less/style.less'
    concat:
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
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-manifest')
    grunt.loadNpmTasks('grunt-img')
    grunt.loadNpmTasks('grunt-contrib-less')

    grunt.registerTask('dev', 'Development environment', ->
      grunt.task.run([
        'concat:coffee'
        'coffee:dev'
        'less:dev'
        'manifest:dev'
        'watch'
      ])
    )
    grunt.registerTask('prod', 'Production environment', ->
      grunt.task.run([
        'concat:coffee'
        'coffee:prod'
        'uglify:prod'
        'less:prod'
        'manifest:prod'
      ])
    )
    grunt.registerTask('package', 'Make deployment package', ->
      grunt.task.run(['prod', 'compress:package'])
    )
  )
