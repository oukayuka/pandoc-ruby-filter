-- Process the given text to find and replace ruby notation.
-- format: the output format (e.g., latex, html)
-- text: the input text to process
function process_str(format, text)
    local result = {}
    local ruby_pattern = "｜(.-)《(.-)》"
    local has_ruby = text:match(ruby_pattern)

    -- Check if the text contains ruby notation
    if has_ruby then
        -- Extract the text before the ruby notation, the kanji, the reading, and the text after the ruby notation
        local before_ruby, kanji, yomi, after_ruby = text:match("(.-)" .. ruby_pattern .. "(.*)")

        -- Add the text before the ruby notation to the result
        if before_ruby and before_ruby ~= "" then
            table.insert(result, pandoc.Str(before_ruby))
        end

        -- Convert the ruby notation according to the output format
        if format:match "latex" then
            table.insert(result, pandoc.RawInline("latex", "\\ruby{" .. kanji .. "}{" .. yomi .. "}"))
        elseif format:match "typst" then
            table.insert(result, pandoc.RawInline("typst", "#ruby[" .. yomi .. "][" .. kanji .. "];"))
        elseif format:match "html" or format:match "epub" then
            table.insert(result, pandoc.RawInline("html", "<ruby>" .. kanji .. "<rp>《</rp><rt>" .. yomi .. "</rt><rp>》</rp></ruby>"))
        elseif format:match "docx" then
            table.insert(result, pandoc.RawInline("openxml", "<w:r><w:ruby><w:rt><w:r><w:t>" .. yomi .. "</w:t></w:r></w:rt><w:rubyBase><w:r><w:t>" .. kanji .. "</w:t></w:r></w:rubyBase></w:ruby></w:r>"))
        else
            table.insert(result, pandoc.Str("｜" .. kanji .. "《" .. yomi .. "》"))
        end

        -- Recursively process the text after the ruby notation
        if after_ruby and after_ruby ~= "" then
            local after_result = process_str(format, after_ruby)
            for _, v in ipairs(after_result) do
                table.insert(result, v)
            end
        end
    else
        -- If the text does not contain ruby notation, add it as is
        table.insert(result, pandoc.Str(text))
    end

    return result
end

-- Replace ruby notation in a Str element according to the output format
function Str(element)
    local format = FORMAT:lower()
    return process_str(format, element.text)
end
