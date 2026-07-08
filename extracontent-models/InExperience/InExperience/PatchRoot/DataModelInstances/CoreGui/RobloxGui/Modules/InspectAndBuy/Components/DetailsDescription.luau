local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local v9 = Roact.PureComponent:extend("DetailsDescription")

function v9.setText(p1) -- line: 18
	-- upvalues: UtilityFunctions (copy)
	local v11 = p1.props.assetInfo or {}
	local v12 = v11.parentBundleId ~= nil
	local v13 = p1.props.bundleInfo or {}

	if v12 then
		local v14 = UtilityFunctions.getBundleId(v11)

		if v13[v14] then
			p1.description = v13[v14].description or ""

			return
		end
	elseif v11 then
		p1.description = v11.description or ""
	end
end
function v9.init(p2) -- line: 34
	-- upvalues: Roact (copy)
	p2.description = ""
	p2.descriptionRef = Roact.createRef()
end
function v9.render(p3) -- line: 39
	-- upvalues: Roact (copy), AppFonts (copy), Colors (copy)
	p3:setText()

	local v17 = p3:calculateSize()

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Size = UDim2.new(1, -20, 0, v17),
		Text = p3.description or "",
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = 16,
		TextWrapped = true,
		Font = AppFonts.default:getDefault(),
		TextColor3 = Colors.White,
		[Roact.Ref] = p3.descriptionRef
	})
end
function v9.calculateSize(p4) -- line: 58
	-- upvalues: TextService (copy), AppFonts (copy)
	if p4.descriptionRef.current and p4.props.assetInfo then
		return TextService:GetTextSize(p4.description, 16, AppFonts.default:getDefault(), Vector2.new(p4.descriptionRef.current.AbsoluteSize.X, 5000)).Y
	end
end

return RoactRodux.UNSTABLE_connect2(function(p5, _) -- line: 70
	local assetId = p5.detailsInformation.assetId

	return {
		view = p5.view,
		assetInfo = p5.assets[assetId],
		detailsInformation = p5.detailsInformation,
		bundleInfo = p5.bundles
	}
end)(v9)
