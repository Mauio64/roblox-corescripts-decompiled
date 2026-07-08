local GuiService = game:GetService("GuiService")
local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Signals = require(InExperienceSideSheetParent.Signals)
local Constants = require(InExperienceSideSheet.Common.Constants)
local v6 = game:DefineFastInt("MaxIGMBackgroundTransparencyPercent", 30)

local function createSideSheetConfigStore() -- line: 22
	-- upvalues: Signals (copy), Constants (copy), GuiService (copy), v6 (copy)
	local v8, v9 = Signals.createSignal(0)
	local v10, v11 = Signals.createSignal(0)
	local v12 = Signals.createComputed(function(p1) -- line: 26
		-- upvalues: v10 (copy), Constants (copy)
		return v10(p1) <= Constants.Breakpoint.HeightSmall
	end)

	local function updateBackgroundTransparency() -- line: 34
		-- upvalues: v9 (copy), GuiService (copy), v6 (copy)
		return v9(GuiService.PreferredTransparency * v6 / 100)
	end

	v9(GuiService.PreferredTransparency * v6 / 100)

	local connection = GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 43
		-- upvalues: v9 (copy), GuiService (copy), v6 (copy)
		v9(GuiService.PreferredTransparency * v6 / 100)
	end)

	return {
		getHeight = v10,
		getIsHeightSmall = v12,
		onHeightChanged = function(n1: number) -- line: 30
			-- upvalues: v11 (copy)
			return v11(n1)
		end,
		getBackgroundTransparency = v8,
		cleanUp = function() -- line: 47
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	}
end

return createSideSheetConfigStore
