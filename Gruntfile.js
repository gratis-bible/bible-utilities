module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    convert: {
      options: {
        explicitArray: false,
      },
      xml2yml: {
        expand:true,
        cwd: 'data/bibles/osis-split/',
        src: ['**/*.xml'],
        dest: 'data/bibles/yml/',
        ext: '.yml'
      }
    }
  });

  grunt.loadNpmTasks('grunt-convert');

  grunt.registerTask('osis2yml', ['convert']);

};
