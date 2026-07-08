local Markdown = script:FindFirstAncestor("Markdown")
local MarkdownParent = Markdown.Parent
local Dash = require(MarkdownParent.Dash)
local BuildTree = require(script.BuildTree)
local PostProcessTree = require(script.PostProcessTree)
local Tokenize = require(script.Tokenize)

require(Markdown.Types)

local UnindentTags = require(script.Parent.UnindentTags)
local IndexTree = require(script.Parent.IndexTree)
local DefaultParserOptions = require(script.Parent.DefaultParserOptions)
local t1 = {}

function t1.safeParse(s1: string, p1) -- line: 18
	-- upvalues: t1 (copy)
	local ok, result = xpcall(function() -- line: 19
		-- upvalues: t1 (copy), s1 (copy), p1 (copy)
		return t1.parse(s1, p1)
	end, function(err) -- line: 21
		return `{ err }\n{ debug.traceback() }`
	end)

	return ok, result
end
function t1.parse(s2: string, p2) -- line: 27
	-- upvalues: Dash (copy), DefaultParserOptions (copy), UnindentTags (copy), Tokenize (copy), BuildTree (copy), PostProcessTree (copy), IndexTree (copy)
	local v17 = Dash.joinDeep(DefaultParserOptions, p2 or {})
	local v18 = UnindentTags(s2)
	local v19 = Tokenize(v18, v17)
	local v20 = BuildTree(v19, v17)

	v20.children = PostProcessTree(v20, v17)

	return IndexTree(v20)
end

return t1
