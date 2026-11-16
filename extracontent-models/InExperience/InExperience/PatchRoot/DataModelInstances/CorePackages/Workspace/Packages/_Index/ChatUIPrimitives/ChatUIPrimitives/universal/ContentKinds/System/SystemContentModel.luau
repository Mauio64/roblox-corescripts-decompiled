require(script.Parent.Parent.Parent.Types)
require(script.Parent.SystemTypes)
local unpackContent = require(script.Parent.Parent.unpackContent)
local SystemContentModel = {}

function SystemContentModel.fromSystem(text: string, iconName: string?)
	return {
		system = { text = text, iconName = iconName }
	}
end

function SystemContentModel.getDetail(p)
	return p.system
end

function SystemContentModel.isSystemMessage(p): boolean
	local content = p.contents[1]
	return content ~= nil and unpackContent(content) == "system"
end

return SystemContentModel
