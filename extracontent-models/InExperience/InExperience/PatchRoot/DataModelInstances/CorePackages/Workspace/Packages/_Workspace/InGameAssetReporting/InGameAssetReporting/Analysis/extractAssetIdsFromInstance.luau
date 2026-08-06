local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

require(InGameAssetReporting.Analysis.Types)

function extractAssetIdsFromInstance(p1) -- line: 5
	local t1 = {
		Package = {},
		Model = {},
		Image = {},
		Mesh = {},
		Text = {},
		Video = {}
	}

	if p1:IsA("PackageLink") and (p1.PackageId ~= "" and p1.VersionNumber > 0) then
		table.insert(t1.Package, {
			id = p1.PackageId,
			version = p1.VersionNumber
		})

		return t1
	end

	if p1:IsA("Model") and p1.SourceAssetId > 0 then
		table.insert(t1.Model, (tostring(p1.SourceAssetId)))

		return t1
	end

	if p1:IsA("MeshPart") and p1.MeshId ~= "" then
		table.insert(t1.Mesh, p1.MeshId)

		if p1.TextureID ~= "" then
			table.insert(t1.Image, p1.TextureID)

			return t1
		end
	elseif (p1.ClassName == "FileMesh" or p1.ClassName == "SpecialMesh" and p1.MeshType == Enum.MeshType.FileMesh) and p1.MeshId ~= "" then
		table.insert(t1.Mesh, p1.MeshId)

		if p1.TextureId ~= "" then
			table.insert(t1.Image, p1.TextureId)

			return t1
		end
	else
		if p1:IsA("ImageLabel") and p1.Image ~= "" then
			table.insert(t1.Image, p1.Image)

			return t1
		end

		if p1:IsA("ImageButton") then
			if p1.Image ~= "" then
				table.insert(t1.Image, p1.Image)
			end

			if p1.HoverImage ~= "" then
				table.insert(t1.Image, p1.HoverImage)
			end

			if p1.PressedImage ~= "" then
				table.insert(t1.Image, p1.PressedImage)

				return t1
			end
		else
			if p1:IsA("Decal") and p1.Texture ~= "" then
				table.insert(t1.Image, p1.Texture)

				return t1
			end

			if p1:IsA("SurfaceAppearance") and p1.ColorMap ~= "" then
				table.insert(t1.Image, p1.ColorMap)

				return t1
			end

			if p1:IsA("TextLabel") and p1.Text ~= "" and game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
				table.insert(t1.Text, p1.Text)

				return t1
			end

			if p1:IsA("TextButton") and p1.Text ~= "" and game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
				table.insert(t1.Text, p1.Text)

				return t1
			end

			if p1:IsA("TextBox") and game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
				if p1.Text ~= "" then
					table.insert(t1.Text, p1.Text)

					return t1
				end

				if p1.PlaceholderText ~= "" then
					table.insert(t1.Text, p1.PlaceholderText)

					return t1
				end
			else
				if not p1:IsA("VideoFrame") then
					return nil
				end

				if p1.Video ~= "" then
					table.insert(t1.Video, p1.Video)

					return t1
				end
			end
		end
	end

	return t1
end

return extractAssetIdsFromInstance
