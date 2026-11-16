local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
require(InGameAssetReporting.Analysis.Types)

function extractAssetIdsFromInstance(instance)
	local v = {
		Package = {},
		Model = {},
		Image = {},
		Mesh = {},
		Text = {},
		Video = {}
	}

	if instance:IsA("PackageLink") and instance.PackageId ~= "" and instance.VersionNumber > 0 then
		table.insert(v.Package, { id = instance.PackageId, version = instance.VersionNumber })
		return v
	end

	if instance:IsA("Model") and instance.SourceAssetId > 0 then
		table.insert(v.Model, (tostring(instance.SourceAssetId)))
		return v
	end

	if instance:IsA("MeshPart") and instance.MeshId ~= "" then
		table.insert(v.Mesh, instance.MeshId)

		if instance.TextureID ~= "" then
			table.insert(v.Image, instance.TextureID)
			return v
		end
	elseif
		(instance.ClassName == "FileMesh" or instance.ClassName == "SpecialMesh" and instance.MeshType == Enum.MeshType.FileMesh)
		and instance.MeshId ~= ""
	then
		table.insert(v.Mesh, instance.MeshId)

		if instance.TextureId ~= "" then
			table.insert(v.Image, instance.TextureId)
			return v
		end
	else
		if instance:IsA("ImageLabel") and instance.Image ~= "" then
			table.insert(v.Image, instance.Image)
			return v
		end

		if instance:IsA("ImageButton") then
			if instance.Image ~= "" then
				table.insert(v.Image, instance.Image)
			end

			if instance.HoverImage ~= "" then
				table.insert(v.Image, instance.HoverImage)
			end

			if instance.PressedImage ~= "" then
				table.insert(v.Image, instance.PressedImage)
				return v
			end
		else
			if instance:IsA("Decal") and instance.Texture ~= "" then
				table.insert(v.Image, instance.Texture)
				return v
			end

			if instance:IsA("SurfaceAppearance") and instance.ColorMap ~= "" then
				table.insert(v.Image, instance.ColorMap)
				return v
			end

			if
				instance:IsA("TextLabel")
				and instance.Text ~= ""
				and game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport")
			then
				table.insert(v.Text, instance.Text)
				return v
			end

			if
				instance:IsA("TextButton")
				and instance.Text ~= ""
				and game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport")
			then
				table.insert(v.Text, instance.Text)
				return v
			end

			if instance:IsA("TextBox") and game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
				if instance.Text ~= "" then
					table.insert(v.Text, instance.Text)
					return v
				end

				if instance.PlaceholderText ~= "" then
					table.insert(v.Text, instance.PlaceholderText)
					return v
				end
			else
				if not instance:IsA("VideoFrame") then
					return nil
				end

				if instance.Video ~= "" then
					table.insert(v.Video, instance.Video)
					return v
				end
			end
		end
	end

	return v
end

return extractAssetIdsFromInstance
