module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    convert: {
      options: {
        explicitArray: false,
      },
      osis2html: {
        expand:true,
        cwd: 'data/bibles/osis/',
        src: ['**/*.xml'],
        dest: 'data/bibles/gh-pages/',
        ext: '.html'
      }
    }
  });

  grunt.loadNpmTasks('grunt-osis');
  grunt.loadNpmTasks('grunt-newer');

  grunt.registerTask('osis2html', ['convert']);

};
