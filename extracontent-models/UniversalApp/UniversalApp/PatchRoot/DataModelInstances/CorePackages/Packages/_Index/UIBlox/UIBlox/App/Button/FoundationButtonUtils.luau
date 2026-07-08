local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Core = scriptParentParentParent.Core
local Foundation = require(scriptParentParentParentParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local uiblox = require(scriptParentParentParentParent.BuilderIcons).Migration.uiblox
local ButtonType = require(scriptParent.Enum.ButtonType)
local StandardButtonSize = require(Core.Button.Enum.StandardButtonSize)
local ImagesInverse = require(scriptParentParent.ImageSet.ImagesInverse)
local t1 = {
	[ButtonType.Alert] = ButtonVariant.Alert,
	[ButtonType.PrimaryContextual] = ButtonVariant.Emphasis,
	[ButtonType.PrimarySystem] = ButtonVariant.SubEmphasis,
	[ButtonType.Secondary] = ButtonVariant.Subtle
}
local t2 = {
	[StandardButtonSize.Regular] = InputSize.Large,
	[StandardButtonSize.Small] = InputSize.Small,
	[StandardButtonSize.XSmall] = InputSize.XSmall
}
local t3 = {
	[StandardButtonSize.Regular] = false,
	[StandardButtonSize.Small] = false,
	[StandardButtonSize.XSmall] = true
}

return {
	buttonMapping = t1,
	sizeMapping = t2,
	findIcon = function(p1) -- line: 38
		-- upvalues: uiblox (copy), ImagesInverse (copy)
		if not p1 then
			return nil
		end

		local v17 = if not (p1.Image and uiblox[p1.Image] ~= nil) then ImagesInverse[p1] else p1.Image

		if v17 == nil then
			warn("Icon not found")
		end

		return v17
	end,
	getSizeMapping = function(p2, uDim2: UDim2?, p3) -- line: 52
		-- upvalues: t2 (copy), InputSize (copy)
		if p2 then
			return t2[p2]
		end

		if uDim2 then
			if uDim2.Y.Offset >= p3.Size.Size_1200 then
				return InputSize.Large
			end

			if uDim2.Y.Scale > 0 then
				return InputSize.Medium
			end

			if uDim2.Y.Offset >= p3.Size.Size_1000 then
				return InputSize.Medium
			end

			if uDim2.Y.Offset >= p3.Size.Size_800 then
				return InputSize.Small
			end

			return InputSize.XSmall
		end

		return nil
	end,
	getWidth = function(s1: string?, uDim2: UDim2?, b1: boolean?) -- line: 71
		-- upvalues: t3 (copy)
		if s1 then
			local v24 = t3[s1]

			if b1 == nil then
				b1 = v24
			end

			if b1 then
				return nil
			end

			return UDim.new(1, 0)
		end

		if uDim2 then
			return uDim2.X
		end

		if b1 then
			return nil
		end

		return UDim.new(1, 0)
	end,
	getMaxWidth = function(s2: string?, n1: number?) -- line: 92
		if s2 == nil then
			return nil
		end

		if n1 == nil then
			return 640
		end

		return n1
	end,
	getTestId = function(s3: string?) -- line: 100
		if not s3 or #s3 == 0 then
			return nil
		end

		return s3:match("data%-testid=([^%s]+)")
	end
}
