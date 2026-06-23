; sokol-shdc @-tag directives.
; The whole tag (e.g. "@vs") is a single token, so highlighting it as one
; keyword is exactly what keeps a formatter from splitting "@vs" into "@ vs".
[
  "@vs"
  "@fs"
  "@cs"
  "@block"
  "@end"
  "@program"
  "@include"
  "@include_block"
  "@ctype"
  "@header"
  "@module"
  "@glsl_options"
  "@hlsl_options"
  "@msl_options"
  "@image_sample_type"
  "@sampler_type"
] @keyword

; Block / program names: @vs vs, @block common, @program render vs fs
(block_directive name: (identifier) @function)
(program_directive name: (identifier) @function)

; Free-form argument of @ctype / @header / @include / @module / options ...
(value_directive value: (value) @string)
