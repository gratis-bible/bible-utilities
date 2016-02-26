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
        dest: 'data/bibles/yml-split/',
        ext: '.yml'
      }
    }
  });

  grunt.loadTasks('grunt-convert/tasks');
  grunt.loadNpmTasks('grunt-newer');

  grunt.registerTask('osis2yml', ['newer:convert']);

};
