local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)

local function getSelectionIsOutsideGuiObject(p1) -- line: 7
	-- upvalues: GuiService (copy)
	return GuiService.SelectedCoreObject and (not GuiService.SelectedCoreObject:IsDescendantOf(p1) and p1 ~= GuiService.SelectedCoreObject)
end
local function useRedirectFocusIntoGuiObject(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), GuiService (copy)
	React.useEffect(function() -- line: 31
		-- upvalues: t1 (copy), GuiService (copy)
		local current = t1.current

		if current then
			if GuiService.SelectedCoreObject and (not GuiService.SelectedCoreObject:IsDescendantOf(current) and current ~= GuiService.SelectedCoreObject) then
				current.Selectable = true
			else
				current.Selectable = false
			end
		end

		local connection = GuiService.Changed:Connect(function(property) -- line: 45
			-- upvalues: t1 (copy), GuiService (copy)
			if property == "SelectedCoreObject" then
				local current2 = t1.current

				if current2 then
					if GuiService.SelectedCoreObject and (not GuiService.SelectedCoreObject:IsDescendantOf(current2) and current2 ~= GuiService.SelectedCoreObject) then
						current2.Selectable = true

						return
					end

					if current2 == GuiService.SelectedCoreObject then
						current2.Selectable = false
						GuiService:Select(current2)

						return
					end

					if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(current2) then
						current2.Selectable = false
					end
				end
			end
		end)

		return function() -- line: 68
			-- upvalues: connection (copy)
			return connection:Disconnect()
		end
	end, {})
end

return useRedirectFocusIntoGuiObject
