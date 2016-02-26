module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    convert: {
      options: {
        explicitArray: false,
      },
      osis2md: {
        expand:true,
        cwd: 'data/bibles/osis/',
        src: ['**/*.xml'],
        dest: 'data/bibles/md/',
        ext: '.md'
      }
    }
  });

  grunt.loadNpmTasks('grunt-osis');
  grunt.loadNpmTasks('grunt-newer');

  grunt.registerTask('osis2yml', ['convert']);

};
