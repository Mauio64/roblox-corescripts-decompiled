local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local parent = script.Parent.Parent
local Colors = require(parent.Colors)
local UtilityFunctions = require(parent.UtilityFunctions)

local extended = Roact.PureComponent:extend("DetailsDescription")

function extended:setText()
	local assetInfo = self.props.assetInfo or {}
	local v = assetInfo.parentBundleId ~= nil

	local bundleInfo = self.props.bundleInfo or {}

	if v then
		local bundleId = UtilityFunctions.getBundleId(assetInfo)

		if bundleInfo[bundleId] then
			self.description = bundleInfo[bundleId].description or ""
		end
	elseif assetInfo then
		self.description = assetInfo.description or ""
	end
end

function extended:init()
	self.description = ""
	self.descriptionRef = Roact.createRef()
end

function extended:render()
	self:setText()
	local size = self:calculateSize()

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Size = UDim2.new(1, -20, 0, size),
		Text = self.description or "",
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = 16,
		TextWrapped = true,
		Font = AppFonts.default:getDefault(),
		TextColor3 = Colors.White,
		[Roact.Ref] = self.descriptionRef
	})
end

function extended:calculateSize()
	if self.descriptionRef.current and self.props.assetInfo then
		return TextService:GetTextSize(
			self.description,
			16,
			AppFonts.default:getDefault(),
			Vector2.new(self.descriptionRef.current.AbsoluteSize.X, 5000)
		).Y
	end
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		view = data.view,
		assetInfo = data.assets[assetId],
		detailsInformation = data.detailsInformation,
		bundleInfo = data.bundles
	}
end)(extended)
