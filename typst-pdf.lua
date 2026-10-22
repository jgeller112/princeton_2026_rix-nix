-- Typst-only cleanup for the PDF backup of the slides
if not quarto.doc.is_format("typst") then return {} end

return {
  {
    -- Speaker notes would otherwise print on (and overflow) the slide
    Div = function(el)
      if el.classes:includes("notes") then return {} end
    end,
    -- Shrink code so long code-walk listings fit on one slide
    CodeBlock = function(el)
      return {
        pandoc.RawBlock("typst", "#[#set text(size: 0.55em); #set par(leading: 0.45em)"),
        el,
        pandoc.RawBlock("typst", "]"),
      }
    end,
    -- Keep inline logos at text height
    Image = function(el)
      if el.classes:includes("inline-logo") then
        el.attributes["height"] = "1em"
        return el
      end
    end,
  }
}
