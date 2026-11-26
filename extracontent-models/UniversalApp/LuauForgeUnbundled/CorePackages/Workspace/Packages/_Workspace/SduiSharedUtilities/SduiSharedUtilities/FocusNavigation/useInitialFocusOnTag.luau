local CollectionService = game:GetService("CollectionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactFocusNavigation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Responsive")
local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport

local function useInitialFocusOnTag(tag, p2)
	local v5

	if fFlagLuaAppMediaGalleryGamepadSupport then
		v5 = Responsive.useLastInput() == Responsive.Input.Directional
	else
		v5 = Responsive.usePreferredInput() == Responsive.Input.Directional
	end

	local v6 = ReactFocusNavigation.useFocusGuiObject()
	local ref = React.useRef(false)

	React.useEffect(function()
		if not v5 then
			return
		end

		local current = p2.current

		if not current then
			return
		end

		for k, v7 in CollectionService:GetTagged(tag) do
			if not ref.current and v7:IsDescendantOf(current) then
				ref.current = true
				v6(v7)
				return
			end
		end

		local connection = CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance)
			if not ref.current and current and instance:IsDescendantOf(current) then
				ref.current = true
				v6(instance)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v5, tag, v6 })
end

return useInitialFocusOnTag
