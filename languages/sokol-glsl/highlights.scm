; ---- sokol @-tag directives -------------------------------------------------
; Each whole tag (e.g. "@vs") is a single keyword token, so a formatter can
; never split it into "@ vs".
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

; Free-form argument of @ctype / @header / @include / @module / options …
(value_directive value: (value) @string)

; ---- embedded GLSL ----------------------------------------------------------
(keyword) @keyword
(type) @type
(number) @number
(comment) @comment
(preproc) @keyword

; gl_* built-in variables and ALL_CAPS constants
((identifier) @variable.builtin
 (#match? @variable.builtin "^gl_"))
((identifier) @constant
 (#match? @constant "^[A-Z][A-Z0-9_]*$"))
