local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent.Parent

local GlobalConfig = require(parent.GlobalConfig)

local Assets = require(parent.Resources.Assets)

local OpenReportDialog = require(parent.Actions.OpenReportDialog)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local Image = Foundation.Image

local strictInterface = t.strictInterface({
	userId = t.optional(t.integer),
	userName = t.optional(t.string),
	LayoutOrder = t.integer,
	dispatchOpenReportDialog = t.callback
})

local function ReportButton(data)
	if GlobalConfig.propValidation then
		assert(strictInterface(data))
	end

	return v(function(callback)
		if FFlagCoreUiMigrateUIBloxToFoundation then
			return Roact.createElement(Image, {
				Image = Assets.Images.ReportIcon,
				Size = UDim2.new(0, 36, 0, 36),
				backgroundStyle = { Transparency = 1 },
				imageStyle = { Color3 = Color3.fromRGB(255, 255, 255), Transparency = 0 },
				LayoutOrder = data.LayoutOrder,
				selection = {
					Selectable = false,
					SelectionImageObject = callback(v2.RoundedRectNoInset)
				},
				onActivated = function()
					data.dispatchOpenReportDialog(data.userId, data.userName)
				end
			})
		end

		return Roact.createElement(ImageSetButton, {
			Selectable = false,
			Image = Assets.Images.ReportIcon,
			Size = UDim2.new(0, 36, 0, 36),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			LayoutOrder = data.LayoutOrder,
			SelectionImageObject = callback(v2.RoundedRectNoInset),
			[Roact.Event.Activated] = function()
				data.dispatchOpenReportDialog(data.userId, data.userName)
			end
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		dispatchOpenReportDialog = function(p, p2)
			callback(OpenReportDialog(p, p2))
		end
	}
end)(ReportButton)
