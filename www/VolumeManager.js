var exec = require('cordova/exec');

exports.getVolume = function (success, error) {
    exec(success, error, 'VolumeManager', 'getVolume', []);
};

exports.setVolume = function (arg0, success, error) {
    exec(success, error, 'VolumeManager', 'setVolume', [arg0]);
};
