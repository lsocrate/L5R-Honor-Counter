module.exports = (grunt) ->
  # ENVIRONMENT
  __ENV__ = null

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
        dest: 'js/main.min.js'
    copy:
      main:
        files: [
          {expand: true, cwd: '/tmp/grunt/<%= pkg.name %>/js/', src: '*', dest: 'js/', filter: 'isFile'}
        ]
    watch:
      scripts:
        files: 'src/*.coffee'
        tasks: ['clean', 'coffee', 'copy']
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

    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-contrib-compress')

    grunt.registerTask('go', 'Switch environments', (env) ->
      __ENV__ = env
      grunt.task.run(['clean', 'coffee'])
      if __ENV__ is 'dev'
        grunt.task.run('copy')
        grunt.task.run('watch')
      else if __ENV__ is 'prod'
        grunt.task.run('uglify')
    )

    grunt.registerTask('package', 'Make deployment package', ->
      grunt.task.run(['go:prod', 'compress:package'])
    )
  )
