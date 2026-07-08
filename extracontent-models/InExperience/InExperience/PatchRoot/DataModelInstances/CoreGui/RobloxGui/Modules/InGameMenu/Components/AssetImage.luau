local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Assets = require(ParentParent.Resources.Assets)

local function makeAssetImageComponent(p1) -- line: 20
	-- upvalues: Roact (copy), Assets (copy), Cryo (copy)
	return Roact.forwardRef(function(p2, p3) -- line: 21
		-- upvalues: Assets (copy), Cryo (copy), Roact (copy), p1 (copy)
		local imageKey = p2.imageKey
		local v27 = Assets.Images[imageKey]
		local v28 = if typeof(v27) ~= "string" then v27 else {
			Image = v27
		}
		local v29 = Cryo.Dictionary.join(p2, {
			imageKey = Cryo.None
		}, v28, {
			BackgroundTransparency = 1
		})

		return Roact.createElement(p1, Cryo.Dictionary.join(v29, {
			[Roact.Ref] = p3
		}))
	end)
end

return {
	Label = Roact.forwardRef(function(p4, p5) -- line: 21
		-- upvalues: Assets (copy), Cryo (copy), Roact (copy), ImageSetLabel (copy)
		local imageKey = p4.imageKey
		local v15 = Assets.Images[imageKey]
		local v16 = if typeof(v15) ~= "string" then v15 else {
			Image = v15
		}
		local v17 = Cryo.Dictionary.join(p4, {
			imageKey = Cryo.None
		}, v16, {
			BackgroundTransparency = 1
		})

		return Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(v17, {
			[Roact.Ref] = p5
		}))
	end),
	Button = Roact.forwardRef(function(p6, p7) -- line: 21
		-- upvalues: Assets (copy), Cryo (copy), Roact (copy), ImageSetButton (copy)
		local imageKey = p6.imageKey
		local v21 = Assets.Images[imageKey]
		local v22 = if typeof(v21) ~= "string" then v21 else {
			Image = v21
		}
		local v23 = Cryo.Dictionary.join(p6, {
			imageKey = Cryo.None
		}, v22, {
			BackgroundTransparency = 1
		})

		return Roact.createElement(ImageSetButton, Cryo.Dictionary.join(v23, {
			[Roact.Ref] = p7
		}))
	end)
}
