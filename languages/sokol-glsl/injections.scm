; Re-parse every embedded-GLSL run with the GLSL grammar so shader code keeps
; full GLSL highlighting. "glsl" resolves to the GLSL language this extension
; bundles (languages/glsl), so no other extension is required. Each `code` node
; is a complete block body, so the GLSL parser sees a whole translation unit.
((code) @injection.content
 (#set! injection.language "glsl"))
