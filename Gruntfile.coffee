module.exports = (grunt) ->
  
  matchdep = require 'matchdep'
  matchdep.filterDev('grunt-*').forEach grunt.loadNpmTasks
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      options:
        bare: true
      files:
        src: ['src/*.coffee']
        dest: 'dist/<%= pkg.name %>.js'
    uglify:
      options:
        report: 'gzip'
      files:
        src: ['dist/<%= pkg.name %>.js'],
        dest: 'dist/<%= pkg.name %>.min.js'
    clean: ['dist']
  
  grunt.registerMultiTask 'codo', 'Generates Codo documentation', ->
    {exec} = require 'child_process'
    DOCGEN = './node_modules/codo/bin/codo'
    DOCOUTPUT = './doc'
    
    done = @async()
    
    exec "#{DOCGEN} -o #{DOCOUTPUT}", done
    
  grunt.registerTask 'default', ['build']
  grunt.registerTask 'build', ['clean', 'coffee', 'uglify']
