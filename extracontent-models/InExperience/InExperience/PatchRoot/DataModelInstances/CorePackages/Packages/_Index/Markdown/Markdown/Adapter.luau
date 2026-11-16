local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(script.AdapterTypes)
require(parent.CommonMark)
local DefaultRules = require(script.DefaultRules)
local Engine = require(script.Engine)
local Registry = require(script.Registry)
local Rules = require(script.Rules)
require(Markdown.Types)

return {
	["Rules"] = Rules,
	build = function(options)
		local v = Registry.build(DefaultRules.register, options or {})
		return table.freeze({
			toRendererAst = function(p, p2)
				return Engine.adapt(v, p, p2)
			end
		})
	end
}
