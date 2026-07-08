local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Cryo = require(SquadsParent.Cryo)
local dependencies = require(Squads.dependencies)
local Foundation = dependencies.Foundation
local React = dependencies.React
local useTokens = Foundation.Hooks.useTokens
local FoundationImage = Foundation.Image
local View = Foundation.View

function HorizontalFacepileGroup(t1: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), Cryo (copy), React (copy), FoundationImage (copy), View (copy)
	local v11 = useTokens()
	local t2 = {
		avatarSize = 0,
		layoutOrder = 1,
		imageBackgroundStyle = nil,
		images = {},
		imageBorderStyle = {
			Color = v11.Color.Extended.Green.Green_800.Color3,
			Transparency = v11.Color.Extended.Green.Green_800.Transparency
		}
	}
	local u13 = Cryo.Dictionary.union(t2, t1)
	local v14 = React.useMemo(function() -- line: 43
		-- upvalues: u13 (ref)
		local v16 = #u13.images

		if v16 <= 0 then
			return 0
		end

		local avatarSize = u13.avatarSize

		for _ = 2, v16 do
			avatarSize += u13.avatarSize - 4
		end

		return avatarSize
	end, {
		#u13.images,
		u13.avatarSize
	})
	local v15 = React.useMemo(function() -- line: 58
		-- upvalues: u13 (ref), React (copy), FoundationImage (copy), v11 (copy)
		local v19 = #u13.images
		local t3 = {}

		for i, v in ipairs(u13.images) do
			local v23 = i ~= 1 and 4 or 0

			table.insert(t3, React.createElement(FoundationImage, {
				tag = "anchor-center-left bg-surface-100 radius-circle",
				Image = v,
				backgroundStyle = if not u13.imageBackgroundStyle then nil else u13.imageBackgroundStyle,
				Size = UDim2.fromOffset(u13.avatarSize, u13.avatarSize),
				Position = UDim2.new(0, u13.avatarSize * (i - 1) - v23 * (i - 1), 0.5, 0),
				ZIndex = v19 - i + 1
			}, {
				UIStroke = React.createElement("UIStroke", {
					Color = if not u13.imageBorderStyle then v11.Color.Extended.Green.Green_800.Color3 else u13.imageBorderStyle.Color,
					Transparency = if not u13.imageBorderStyle then v11.Color.Extended.Green.Green_800.Transparency else u13.imageBorderStyle.Transparency,
					Thickness = v11.Stroke.Thick
				})
			}))
		end

		return t3
	end, {
		u13.avatarSize,
		u13.images,
		u13.imageBackgroundStyle,
		u13.imageBorderStyle
	})

	return React.createElement(View, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(v14, u13.avatarSize),
		LayoutOrder = if not u13.layoutOrder then nil else u13.layoutOrder
	}, { v15 })
end

return HorizontalFacepileGroup
