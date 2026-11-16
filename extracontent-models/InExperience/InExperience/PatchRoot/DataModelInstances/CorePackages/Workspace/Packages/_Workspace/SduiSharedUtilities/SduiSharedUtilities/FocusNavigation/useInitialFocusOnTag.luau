local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local CollectionService = game:GetService("CollectionService")

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport

local function useInitialFocusOnTag(tag: string, p)
	local v

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v = Responsive.useLastInput() == Responsive.Input.Directional
	else
		v = Responsive.usePreferredInput() == Responsive.Input.Directional
	end

	local v2 = ReactFocusNavigation.useFocusGuiObject()
	local ref = React.useRef(false)

	React.useEffect(function()
		if not v then
			return
		end

		local current = p.current

		if not current then
			return
		end

		for _, v3 in CollectionService:GetTagged(tag) do
			if not ref.current and v3:IsDescendantOf(current) then
				ref.current = true
				v2(v3)
				return
			end
		end

		local connection = CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance)
			if not ref.current and current and instance:IsDescendantOf(current) then
				ref.current = true
				v2(instance)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v, tag, v2 })
end

return useInitialFocusOnTag
