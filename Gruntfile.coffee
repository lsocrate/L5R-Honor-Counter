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
        dest: 'js/main.min.js'
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

    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-contrib-compress')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.loadNpmTasks('grunt-contrib-concat')

    grunt.registerTask('go', 'Switch environments', (env) ->
      grunt.task.run(['clean', 'coffee', 'sass', 'concat'])
      if env is 'dev'
        grunt.task.run('copy')
        grunt.task.run('watch')
      else if env is 'prod'
        grunt.task.run('uglify')
    )

    grunt.registerTask('package', 'Make deployment package', ->
      grunt.task.run(['go:prod', 'compress:package'])
    )
  )
