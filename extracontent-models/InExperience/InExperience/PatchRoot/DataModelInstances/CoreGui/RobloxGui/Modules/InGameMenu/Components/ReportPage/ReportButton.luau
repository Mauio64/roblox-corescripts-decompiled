local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent.Parent
local GlobalConfig = require(ParentParent.GlobalConfig)
local Assets = require(ParentParent.Resources.Assets)
local OpenReportDialog = require(ParentParent.Actions.OpenReportDialog)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v14 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v15 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local FoundationImage = Foundation.Image
local v17 = t.strictInterface({
	userId = t.optional(t.integer),
	userName = t.optional(t.string),
	LayoutOrder = t.integer,
	dispatchOpenReportDialog = t.callback
})

local function ReportButton(p1) -- line: 37
	-- upvalues: GlobalConfig (copy), v17 (copy), v14 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), FoundationImage (copy), Assets (copy), v15 (copy), ImageSetButton (copy)
	if GlobalConfig.propValidation then
		assert(v17(p1))
	end

	return v14(function(p2) -- line: 42
		-- upvalues: FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), FoundationImage (copy), Assets (copy), p1 (copy), v15 (copy), ImageSetButton (copy)
		if FFlagCoreUiMigrateUIBloxToFoundation then
			return Roact.createElement(FoundationImage, {
				Image = Assets.Images.ReportIcon,
				Size = UDim2.new(0, 36, 0, 36),
				backgroundStyle = {
					Transparency = 1
				},
				imageStyle = {
					Transparency = 0,
					Color3 = Color3.fromRGB(255, 255, 255)
				},
				LayoutOrder = p1.LayoutOrder,
				selection = {
					Selectable = false,
					SelectionImageObject = p2(v15.RoundedRectNoInset)
				},
				onActivated = function() -- line: 57
					-- upvalues: p1 (copy)
					p1.dispatchOpenReportDialog(p1.userId, p1.userName)
				end
			})
		end

		return Roact.createElement(ImageSetButton, {
			Selectable = false,
			Image = Assets.Images.ReportIcon,
			Size = UDim2.new(0, 36, 0, 36),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			LayoutOrder = p1.LayoutOrder,
			SelectionImageObject = p2(v15.RoundedRectNoInset),
			[Roact.Event.Activated] = function() -- line: 70
				-- upvalues: p1 (copy)
				p1.dispatchOpenReportDialog(p1.userId, p1.userName)
			end
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p3) -- line: 78
	-- upvalues: OpenReportDialog (copy)
	return {
		dispatchOpenReportDialog = function(p4, p5) -- line: 80
			-- upvalues: p3 (copy), OpenReportDialog (copy)
			p3(OpenReportDialog(p4, p5))
		end
	}
end)(ReportButton)
