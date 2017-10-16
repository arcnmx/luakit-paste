local modes = require("modes")

modes.add_binds("insert", {
    { "<Shift-Insert>", "Paste current selection into the page", function (w)
        local value = luakit.selection.primary
        if (not value) or #value == 0 then
            return
        end

        -- Stolen from lib/open_editor.lua
        value = value:gsub("^%s*(.-)%s*$", "%1")
        value = string.format("%q", value):sub(2, -2)
        value = value:gsub("\\\n", "\\n")

        -- http://stackoverflow.com/questions/11076975/insert-text-into-textarea-at-cursor-position-javascript
        w.view:eval_js(string.format([=[
            var elem = document.activeElement;
            var value = "%s";
            if (elem.selectionStart || elem.selectionStart == '0') {
                var startPos = elem.selectionStart;
                var endPos = elem.selectionEnd;
                elem.value = elem.value.substring(0, startPos)
                    + value
                    + elem.value.substring(endPos, elem.value.length);
                elem.selectionStart = startPos + value.length;
                elem.selectionEnd = startPos + value.length;
            } else {
                elem.value += value;
            }
        ]=], value), { no_return = true })
    end },
})
