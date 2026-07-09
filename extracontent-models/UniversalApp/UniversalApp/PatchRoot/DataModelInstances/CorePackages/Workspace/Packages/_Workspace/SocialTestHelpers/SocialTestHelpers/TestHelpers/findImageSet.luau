local SocialTestHelpers = script:FindFirstAncestor("SocialTestHelpers")
local dependencies = require(SocialTestHelpers.dependencies)
local UIBlox = dependencies.UIBlox
local BuilderIcons = dependencies.BuilderIcons
local Migration = BuilderIcons.Migration

return function(p1) -- line: 7
	-- upvalues: UIBlox (copy), Migration (copy), BuilderIcons (copy)
	local v7 = UIBlox.App.ImageSet.Images[p1]

	if Migration.uiblox[p1] or Migration.luaApps[p1] then
		local v8 = Migration.uiblox[p1] or Migration.luaApps[p1]

		return {
			Image = nil,
			ImageRectSize = nil,
			ImageRectOffset = nil,
			Text = v8.name,
			FontFace = BuilderIcons.Font[v8.variant]
		}
	end

	return {
		Text = nil,
		FontFace = nil,
		Image = v7.Image,
		ImageRectSize = v7.ImageRectSize,
		ImageRectOffset = v7.ImageRectOffset
	}
end
