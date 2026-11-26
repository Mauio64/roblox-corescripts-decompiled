local module = require("@luauforge/bundled/ide")
local getSduiComponentRegistry = module.getSduiComponentRegistry
local sduiComponentType = module.SduiComponentType

local module2 = require("@luauforge/bundled/idf")
local fFlagSduiMarkdownTextComponentEnabled = module2.FFlagSduiMarkdownTextComponentEnabled
local fFlagGroupForumsDiscoverySdui = module2.FFlagGroupForumsDiscoverySdui
local fFlagEnableGroupSidebarSdui = module2.FFlagEnableGroupSidebarSdui

local function registerGroupsUiComponents()
	local v5 = {
		[sduiComponentType.MarkdownText] = fFlagSduiMarkdownTextComponentEnabled and {
			getLazyComponent = function()
				return require("@luauforge/bundled/idg")
			end
		} or nil,
		[sduiComponentType.GroupForumPostPreview] = fFlagGroupForumsDiscoverySdui and {
			getLazyComponent = function()
				return require("@luauforge/bundled/idl")
			end
		} or nil,
		[sduiComponentType.GroupSection] = fFlagEnableGroupSidebarSdui and {
			getLazyComponent = function()
				return require("@luauforge/bundled/ido")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerGroupsUiComponents
