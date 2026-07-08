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
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local v14 = t.strictInterface({
	userId = t.optional(t.integer),
	userName = t.optional(t.string),
	LayoutOrder = t.integer,
	dispatchOpenReportDialog = t.callback
})

local function ReportButton(p1) -- line: 28
	-- upvalues: GlobalConfig (copy), v14 (copy), withSelectionCursorProvider (copy), Roact (copy), ImageSetButton (copy), Assets (copy), CursorKind (copy)
	if GlobalConfig.propValidation then
		assert(v14(p1))
	end

	return withSelectionCursorProvider(function(p2) -- line: 33
		-- upvalues: Roact (copy), ImageSetButton (copy), Assets (copy), p1 (copy), CursorKind (copy)
		return Roact.createElement(ImageSetButton, {
			Selectable = false,
			Image = Assets.Images.ReportIcon,
			Size = UDim2.new(0, 36, 0, 36),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			LayoutOrder = p1.LayoutOrder,
			SelectionImageObject = p2(CursorKind.RoundedRectNoInset),
			[Roact.Event.Activated] = function() -- line: 42
				-- upvalues: p1 (copy)
				p1.dispatchOpenReportDialog(p1.userId, p1.userName)
			end
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p3) -- line: 49
	-- upvalues: OpenReportDialog (copy)
	return {
		dispatchOpenReportDialog = function(p4, p5) -- line: 51
			-- upvalues: p3 (copy), OpenReportDialog (copy)
			p3(OpenReportDialog(p4, p5))
		end
	}
end)(ReportButton)
