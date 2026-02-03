{ lib, runCommand

, buildElmApplication
}:

{ name
, enableDebugger ? true
}:

let
  fs = lib.fileset;

  elmOptions =
    if enableDebugger then
      { inherit enableDebugger; }
    else
      {
        doElmFormat = true;
        enableOptimizations = true;
        doMinification = true;
        outputMin = "app.js";
        useTerser = true;
      };

  js = buildElmApplication ({
    name = "elm-super-rentals-js";
    src = fs.toSource {
      root = ../.;
      fileset = fs.unions [
        ../src
        ../elm.json
      ];
    };
    elmLock = ../elm.lock;
    output = "app.js";
  } // elmOptions);
in
runCommand name {} ''
  mkdir "$out"

  cp -r ${../public}/* "$out"
  cp ${js}/app.js "$out"
''
