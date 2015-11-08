module.exports = function (grunt) {
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-browserify');

  grunt.initConfig({
    coffee: {
      client: {
        expand: true,
        options: {
          sourceMap: true
        },
        src: ['client/*.coffee', 'test/*.coffee'],
        ext: '.js'
      }
    },

    browserify: {
      packageClient: {
        src: ['./client/cytodemo.coffee'],
        dest: './client/cytodemo.js',
        options: {
          transform: ['coffeeify'],
          browserifyOptions: {
            extensions: ".coffee"
          }
        }
      }
    },

    mochaTest: {
      test: {
        options: {
          reporter: 'spec'
        },
        src: ['test/**/*.js']
      }
    },


    watch: {
      all: {
        files: ['client/*.coffee', 'test/*.coffee'],
        tasks: ['coffee','mochaTest']
      }
    }
  });

  grunt.registerTask('build', ['browserify:packageClient', 'mochaTest']);
  grunt.registerTask('default', ['build']);

};
