local function remote()
	local morph = Instance.new("Folder")
	morph.Name = "Morph"

	local add = Instance.new("RemoteEvent")
	add.Name = "_add"
	add.Parent = morph

	local remove = Instance.new("RemoteEvent")
	remove.Name = "_remove"
	remove.Parent = morph

	local request = Instance.new("BindableEvent")
	request.Name = "_request"
	request.Parent = morph
	return morph
end

local function _script()
	local scripts = Instance.new("Folder")
	scripts.Name = "Scripts"

	local morphService = Instance.new("Script")
	morphService.Name = "MorphService"
	morphService.Parent = scripts

	local useMorphService = Instance.new("Script")
	useMorphService.Name = "UseMorphService"
	useMorphService.Parent = scripts
	
	morphService.Source = [[--!nocheck

-- 0.0.1

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Remotes = ReplicatedStorage:WaitForChild('Morph')
local RunService = game:GetService('RunService')

local cCreate = coroutine.create
local cResume = coroutine.resume

local HUMANOID_MORPH_BASE_NAME = 'MorphBase'
local MORPH_PARTS_NAME = 'MorphParts'

local function MorphPlayer(player: Player, morph: Model, removeHats: boolean)
	local character = player.Character
	local morphCharacter = morph:FindFirstChild('Character')
	
	if character:FindFirstChild(MORPH_PARTS_NAME) == nil then
		local morphParts = Instance.new('Folder')
		morphParts.Name = MORPH_PARTS_NAME
		morphParts.Parent = character

		local morphWelds = Instance.new('Folder')
		morphWelds.Name = 'morphWelds'
		morphWelds.Parent = morphParts

		local function morphPart(baseName: string, middle: BasePart, parts: {BasePart})
			local bodyPart = character:FindFirstChild(baseName) :: BasePart

			if bodyPart ~= nil then
				local baseFolder = Instance.new('Folder')
				baseFolder.Parent = morphParts
				baseFolder.Name = baseName

				middle = middle:Clone()
				middle.Parent = baseFolder

				for index,part in parts do
					local newPart = part:Clone()
					newPart.Parent = baseFolder
					newPart.Anchored = false
					newPart.CanCollide = false

					local weld = Instance.new('Weld')
					weld.Part0 = middle
					weld.Part1 = newPart

					weld.C1 = part.CFrame:Inverse() * middle.CFrame

					weld.Parent = morphWelds
				end

				middle.Anchored = false
				middle.CanCollide = false

				local middleWeld = Instance.new('Weld')
				middleWeld.Parent = character
				middleWeld.Part0 = bodyPart
				middleWeld.Part1 = middle

				middleWeld.Parent = morphWelds
			end
		end

		for i,v in morph:GetChildren() do
			if (v:IsA('Folder') and v:FindFirstChild('Middle')) then
				local middle = v.Middle
				local parts = {}
				for _,part in v:GetDescendants() :: {BasePart} do
					if part:IsA('BasePart') and part ~= middle then
						table.insert(parts, part)
					end
				end
				cResume(cCreate(morphPart), v.Name,  middle, parts, v.Middle)
			end
		end

		(function()
			if morph:FindFirstChild('removehats?') then
				if morph['removehats?'].Value == false then
					return
				end
			end
			if removeHats == true then
				for i,v in character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Destroy()
					end
				end
			end
			do
				local ShirtInMorph = morphCharacter:FindFirstChildWhichIsA('Shirt')
				if ShirtInMorph then
					local ClothInCharacter = character:FindFirstChildWhichIsA('Shirt')
					if ClothInCharacter then
						ClothInCharacter:Destroy()
					end
					ShirtInMorph:Clone().Parent = character
				end
				local PantsInMorph = morphCharacter:FindFirstChildWhichIsA('Pants')
				if PantsInMorph then
					local ClothInCharacter = character:FindFirstChildWhichIsA('Pants')
					if ClothInCharacter then
						ClothInCharacter:Destroy()
					end
					PantsInMorph:Clone().Parent = character
				end
			end
		end)()
	end
end

local function removeMorph(player: Player)
	local character = player.Character
	if character:FindFirstChild(MORPH_PARTS_NAME) ~= nil then
		character[MORPH_PARTS_NAME]:Destroy()		
	end
end

Remotes._add.OnServerEvent:Connect(function(player, ...)
	player:Kick('no you cannot')
end)

Remotes._remove.OnServerEvent:Connect(function(player, ...)
	player:Kick('no you cannot')
end)

Remotes._request.Event:Connect(function(remotename, ...)
	local player = select(1, ...) :: Player
	if RunService:IsServer() then
		if player then
			if remotename == '_add' then
				MorphPlayer(...)
			elseif remotename == '_remove' then
				removeMorph(...)
			end
		end
	else
		if player then
			player:Kick('No.')
		else
			warn('aww i cant')
		end
	end
end)]]
	
	useMorphService.Source = [[-- 0.0.1

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local MorphRemotes = ReplicatedStorage.Morph

local HUMANOID_MORPH_BASE_NAME = 'MorphBase'

for i,v in workspace:GetDescendants() :: {Humanoid} do
	if v:IsA('Humanoid') == true and v.Name == HUMANOID_MORPH_BASE_NAME then
		local modelBase = v.Parent.Parent

		if modelBase:FindFirstChild('Character') then
			local clickDetector = Instance.new('ClickDetector')
			clickDetector.Parent = modelBase
			clickDetector.MouseClick:Connect(function(player)
				local character = player.Character
				if character:FindFirstChild('MorphParts') == nil then
					MorphRemotes._request:Fire('_add', player, modelBase, true)
				else
					MorphRemotes._request:Fire('_remove', player)
				end
			end)
		end
	end
end]]
	
	return scripts
end

local function uniform()
	local uniforms = Instance.new("Folder")
	uniforms.Name = "Uniforms"
	
	local morphyR6 = Instance.new("Model")
	morphyR6.Name = "Morphy_R6"
	morphyR6.WorldPivot = CFrame.new(-49.2041016, 3.80500507, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999881)

	local character = Instance.new("Model")
	character.Name = "Character"
	character.WorldPivot = CFrame.new(27.0458984, 4.5, -11.7394409, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Anchored = true
	head.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	head.CFrame = CFrame.new(-49.2041016, 5.80500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	head.Rotation = Vector3.new(-180, 0, -180)
	head.Size = Vector3.new(2, 1, 1)
	head.TopSurface = Enum.SurfaceType.Smooth

	local mesh = Instance.new("SpecialMesh")
	mesh.Name = "Mesh"
	mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
	mesh.Parent = head

	local face = Instance.new("Decal")
	face.Name = "face"
	face.Texture = "rbxasset://textures/face.png"
	face.Parent = head

	head.Parent = character

	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Anchored = true
	torso.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	torso.CFrame = CFrame.new(-49.2041016, 4.30500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	torso.LeftSurface = Enum.SurfaceType.Weld
	torso.RightSurface = Enum.SurfaceType.Weld
	torso.Rotation = Vector3.new(-180, 0, -180)
	torso.Size = Vector3.new(2, 2, 1)
	torso.Parent = character

	local leftArm = Instance.new("Part")
	leftArm.Name = "Left Arm"
	leftArm.Anchored = true
	leftArm.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	leftArm.CFrame = CFrame.new(-47.7041016, 4.30500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	leftArm.CanCollide = false
	leftArm.Rotation = Vector3.new(-180, 0, -180)
	leftArm.Size = Vector3.new(1, 2, 1)
	leftArm.Parent = character

	local rightArm = Instance.new("Part")
	rightArm.Name = "Right Arm"
	rightArm.Anchored = true
	rightArm.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	rightArm.CFrame = CFrame.new(-50.7041016, 4.30500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	rightArm.CanCollide = false
	rightArm.Rotation = Vector3.new(-180, 0, -180)
	rightArm.Size = Vector3.new(1, 2, 1)
	rightArm.Parent = character

	local leftLeg = Instance.new("Part")
	leftLeg.Name = "Left Leg"
	leftLeg.Anchored = true
	leftLeg.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	leftLeg.BottomSurface = Enum.SurfaceType.Smooth
	leftLeg.CFrame = CFrame.new(-48.7041016, 2.30500293, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	leftLeg.CanCollide = false
	leftLeg.Rotation = Vector3.new(-180, 0, -180)
	leftLeg.Size = Vector3.new(1, 2, 1)
	leftLeg.Parent = character

	local rightLeg = Instance.new("Part")
	rightLeg.Name = "Right Leg"
	rightLeg.Anchored = true
	rightLeg.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	rightLeg.BottomSurface = Enum.SurfaceType.Smooth
	rightLeg.CFrame = CFrame.new(-49.7041016, 2.30500293, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	rightLeg.CanCollide = false
	rightLeg.Rotation = Vector3.new(-180, 0, -180)
	rightLeg.Size = Vector3.new(1, 2, 1)
	rightLeg.Parent = character

	local morphBase = Instance.new("Humanoid")
	morphBase.Name = "MorphBase"
	morphBase.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	morphBase.HealthDisplayDistance = 0
	morphBase.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	morphBase.UseJumpPower = false

	local animator = Instance.new("Animator")
	animator.Name = "Animator"
	animator.Parent = morphBase

	local humanoidDescription = Instance.new("HumanoidDescription")
	humanoidDescription.Name = "HumanoidDescription"
	humanoidDescription.BodyTypeScale = 0
	humanoidDescription.Face = 2.36e+08
	humanoidDescription.FaceAccessory = "5509208884"
	humanoidDescription.HatAccessory = "4420280348"
	humanoidDescription.HeadColor = Color3.new(0.8, 0.557, 0.412)
	humanoidDescription.LeftArmColor = Color3.new(0.8, 0.557, 0.412)
	humanoidDescription.LeftLegColor = Color3.new(0.8, 0.557, 0.412)
	humanoidDescription.Pants = 7.22e+09
	humanoidDescription.ProportionScale = 0
	humanoidDescription.RightArmColor = Color3.new(0.8, 0.557, 0.412)
	humanoidDescription.RightLegColor = Color3.new(0.8, 0.557, 0.412)
	humanoidDescription.Shirt = 7.22e+09
	humanoidDescription.TorsoColor = Color3.new(0.8, 0.557, 0.412)
	humanoidDescription.Parent = morphBase

	morphBase.Parent = character

	local humanoidRootPart = Instance.new("Part")
	humanoidRootPart.Name = "HumanoidRootPart"
	humanoidRootPart.Anchored = true
	humanoidRootPart.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	humanoidRootPart.BottomSurface = Enum.SurfaceType.Smooth
	humanoidRootPart.CFrame = CFrame.new(-49.2041016, 4.30500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	humanoidRootPart.CanCollide = false
	humanoidRootPart.Rotation = Vector3.new(-180, 0, -180)
	humanoidRootPart.Size = Vector3.new(2, 2, 1)
	humanoidRootPart.TopSurface = Enum.SurfaceType.Smooth
	humanoidRootPart.Transparency = 1
	humanoidRootPart.Parent = character

	character.Parent = morphyR6

	local head1 = Instance.new("Folder")
	head1.Name = "Head"

	local middle = Instance.new("Part")
	middle.Name = "Middle"
	middle.Anchored = true
	middle.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	middle.BrickColor = BrickColor.new("Nougat")
	middle.CFrame = CFrame.new(-49.2041016, 5.80500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	middle.Color = Color3.new(0.8, 0.557, 0.412)
	middle.Rotation = Vector3.new(-180, 0, -180)
	middle.Size = Vector3.new(2, 1, 1)
	middle.TopSurface = Enum.SurfaceType.Smooth
	middle.Transparency = 1
	middle.Parent = head1

	head1.Parent = morphyR6

	local leftArm1 = Instance.new("Folder")
	leftArm1.Name = "Left Arm"

	local middle1 = Instance.new("Part")
	middle1.Name = "Middle"
	middle1.Anchored = true
	middle1.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	middle1.BrickColor = BrickColor.new("Nougat")
	middle1.CFrame = CFrame.new(-47.7041016, 4.30500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	middle1.CanCollide = false
	middle1.Color = Color3.new(0.8, 0.557, 0.412)
	middle1.Rotation = Vector3.new(-180, 0, -180)
	middle1.Size = Vector3.new(1, 2, 1)
	middle1.Transparency = 1
	middle1.Parent = leftArm1

	leftArm1.Parent = morphyR6

	local leftLeg1 = Instance.new("Folder")
	leftLeg1.Name = "Left Leg"

	local middle2 = Instance.new("Part")
	middle2.Name = "Middle"
	middle2.Anchored = true
	middle2.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	middle2.BottomSurface = Enum.SurfaceType.Smooth
	middle2.BrickColor = BrickColor.new("Nougat")
	middle2.CFrame = CFrame.new(-48.7041016, 2.30500293, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	middle2.CanCollide = false
	middle2.Color = Color3.new(0.8, 0.557, 0.412)
	middle2.Rotation = Vector3.new(-180, 0, -180)
	middle2.Size = Vector3.new(1, 2, 1)
	middle2.Transparency = 1
	middle2.Parent = leftLeg1

	leftLeg1.Parent = morphyR6

	local rightArm1 = Instance.new("Folder")
	rightArm1.Name = "Right Arm"

	local middle3 = Instance.new("Part")
	middle3.Name = "Middle"
	middle3.Anchored = true
	middle3.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	middle3.BrickColor = BrickColor.new("Nougat")
	middle3.CFrame = CFrame.new(-50.7041016, 4.30500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	middle3.CanCollide = false
	middle3.Color = Color3.new(0.8, 0.557, 0.412)
	middle3.Rotation = Vector3.new(-180, 0, -180)
	middle3.Size = Vector3.new(1, 2, 1)
	middle3.Transparency = 1
	middle3.Parent = rightArm1

	rightArm1.Parent = morphyR6

	local rightLeg1 = Instance.new("Folder")
	rightLeg1.Name = "Right Leg"

	local middle4 = Instance.new("Part")
	middle4.Name = "Middle"
	middle4.Anchored = true
	middle4.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	middle4.BottomSurface = Enum.SurfaceType.Smooth
	middle4.BrickColor = BrickColor.new("Nougat")
	middle4.CFrame = CFrame.new(-49.7041016, 2.30500293, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	middle4.CanCollide = false
	middle4.Color = Color3.new(0.8, 0.557, 0.412)
	middle4.Rotation = Vector3.new(-180, 0, -180)
	middle4.Size = Vector3.new(1, 2, 1)
	middle4.Transparency = 1
	middle4.Parent = rightLeg1

	rightLeg1.Parent = morphyR6

	local torso1 = Instance.new("Folder")
	torso1.Name = "Torso"

	local middle5 = Instance.new("Part")
	middle5.Name = "Middle"
	middle5.Anchored = true
	middle5.AssemblyLinearVelocity = Vector3.new(1.86e-38, 1.95e-05, 1.65e-38)
	middle5.BrickColor = BrickColor.new("Nougat")
	middle5.CFrame = CFrame.new(-49.2041016, 4.30500221, 116.240555, -1, 0, 0, 0, 1, 0, 0, 0, -0.999999762)
	middle5.Color = Color3.new(0.8, 0.557, 0.412)
	middle5.LeftSurface = Enum.SurfaceType.Weld
	middle5.RightSurface = Enum.SurfaceType.Weld
	middle5.Rotation = Vector3.new(-180, 0, -180)
	middle5.Size = Vector3.new(2, 2, 1)
	middle5.Transparency = 1
	middle5.Parent = torso1

	torso1.Parent = morphyR6
	
	morphyR6.Parent = uniforms
	
	local morphyR15 = Instance.new("Model")
	morphyR15.Name = "Morphy_R15"
	morphyR15.WorldPivot = CFrame.new(-44.9214897, 3.80766606, 116.282913, -1, 0, 0, 0, 1, 0, 0, 0, -1)

	local character = Instance.new("Model")
	character.Name = "Character"
	character.WorldPivot = CFrame.new(31.3282623, 3.20266104, -11.6969604, -1, 0, 0, 0, 1, 0, 0, 0, -1)

	local humanoidRootPart = Instance.new("Part")
	humanoidRootPart.Name = "HumanoidRootPart"
	humanoidRootPart.Anchored = true
	humanoidRootPart.CFrame = CFrame.new(-44.9217377, 4.50778818, 116.283035, 1, 0, 8.74227766e-08, 0, 1, 0, -8.74227766e-08, 0, 1)
	humanoidRootPart.Size = Vector3.new(2, 2, 1)
	humanoidRootPart.Transparency = 1
	humanoidRootPart.Parent = character

	local leftHand = Instance.new("MeshPart")
	leftHand.Name = "LeftHand"
	leftHand.Anchored = true
	leftHand.CFrame = CFrame.new(-43.4217377, 3.45763397, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	leftHand.CanCollide = false
	leftHand.Rotation = Vector3.new(-180, 0, -180)
	leftHand.Size = Vector3.new(1, 0.3, 1)
	leftHand.Parent = character

	local leftLowerArm = Instance.new("MeshPart")
	leftLowerArm.Name = "LeftLowerArm"
	leftLowerArm.Anchored = true
	leftLowerArm.CFrame = CFrame.new(-43.4217377, 4.08360815, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	leftLowerArm.CanCollide = false
	leftLowerArm.Rotation = Vector3.new(-180, 0, -180)
	leftLowerArm.Size = Vector3.new(1, 1.05, 1)
	leftLowerArm.Parent = character

	local leftUpperArm = Instance.new("MeshPart")
	leftUpperArm.Name = "LeftUpperArm"
	leftUpperArm.Anchored = true
	leftUpperArm.CFrame = CFrame.new(-43.4217377, 4.67635202, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	leftUpperArm.CanCollide = false
	leftUpperArm.Rotation = Vector3.new(-180, 0, -180)
	leftUpperArm.Size = Vector3.new(1, 1.17, 1)
	leftUpperArm.Parent = character

	local rightHand = Instance.new("MeshPart")
	rightHand.Name = "RightHand"
	rightHand.Anchored = true
	rightHand.CFrame = CFrame.new(-46.4217377, 3.45763397, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	rightHand.CanCollide = false
	rightHand.Rotation = Vector3.new(-180, 0, -180)
	rightHand.Size = Vector3.new(1, 0.3, 1)
	rightHand.Parent = character

	local rightLowerArm = Instance.new("MeshPart")
	rightLowerArm.Name = "RightLowerArm"
	rightLowerArm.Anchored = true
	rightLowerArm.CFrame = CFrame.new(-46.4217377, 4.08360815, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	rightLowerArm.CanCollide = false
	rightLowerArm.Rotation = Vector3.new(-180, 0, -180)
	rightLowerArm.Size = Vector3.new(1, 1.05, 1)
	rightLowerArm.Parent = character

	local rightUpperArm = Instance.new("MeshPart")
	rightUpperArm.Name = "RightUpperArm"
	rightUpperArm.Anchored = true
	rightUpperArm.CFrame = CFrame.new(-46.4217377, 4.67635202, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	rightUpperArm.CanCollide = false
	rightUpperArm.Rotation = Vector3.new(-180, 0, -180)
	rightUpperArm.Size = Vector3.new(1, 1.17, 1)
	rightUpperArm.Parent = character

	local upperTorso = Instance.new("MeshPart")
	upperTorso.Name = "UpperTorso"
	upperTorso.Anchored = true
	upperTorso.CFrame = CFrame.new(-44.9217377, 4.50766277, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	upperTorso.Rotation = Vector3.new(-180, 0, -180)
	upperTorso.Size = Vector3.new(2, 1.6, 1)
	upperTorso.Parent = character

	local leftFoot = Instance.new("MeshPart")
	leftFoot.Name = "LeftFoot"
	leftFoot.Anchored = true
	leftFoot.CFrame = CFrame.new(-44.4217377, 1.45768094, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	leftFoot.CanCollide = false
	leftFoot.Rotation = Vector3.new(-180, 0, -180)
	leftFoot.Size = Vector3.new(1, 0.3, 1)
	leftFoot.Parent = character

	local leftLowerLeg = Instance.new("MeshPart")
	leftLowerLeg.Name = "LeftLowerLeg"
	leftLowerLeg.Anchored = true
	leftLowerLeg.CFrame = CFrame.new(-44.4217377, 2.10677695, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	leftLowerLeg.CanCollide = false
	leftLowerLeg.Rotation = Vector3.new(-180, 0, -180)
	leftLowerLeg.Size = Vector3.new(1, 1.19, 1)
	leftLowerLeg.Parent = character

	local leftUpperLeg = Instance.new("MeshPart")
	leftUpperLeg.Name = "LeftUpperLeg"
	leftUpperLeg.Anchored = true
	leftUpperLeg.CFrame = CFrame.new(-44.4217377, 2.88689804, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	leftUpperLeg.CanCollide = false
	leftUpperLeg.Rotation = Vector3.new(-180, 0, -180)
	leftUpperLeg.Size = Vector3.new(1, 1.22, 1)
	leftUpperLeg.Parent = character

	local rightFoot = Instance.new("MeshPart")
	rightFoot.Name = "RightFoot"
	rightFoot.Anchored = true
	rightFoot.CFrame = CFrame.new(-45.4217377, 1.45768094, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	rightFoot.CanCollide = false
	rightFoot.Rotation = Vector3.new(-180, 0, -180)
	rightFoot.Size = Vector3.new(1, 0.3, 1)
	rightFoot.Parent = character

	local rightLowerLeg = Instance.new("MeshPart")
	rightLowerLeg.Name = "RightLowerLeg"
	rightLowerLeg.Anchored = true
	rightLowerLeg.CFrame = CFrame.new(-45.4217377, 2.10677695, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	rightLowerLeg.CanCollide = false
	rightLowerLeg.Rotation = Vector3.new(-180, 0, -180)
	rightLowerLeg.Size = Vector3.new(1, 1.19, 1)
	rightLowerLeg.Parent = character

	local rightUpperLeg = Instance.new("MeshPart")
	rightUpperLeg.Name = "RightUpperLeg"
	rightUpperLeg.Anchored = true
	rightUpperLeg.CFrame = CFrame.new(-45.4217377, 2.88689804, 116.28299, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	rightUpperLeg.CanCollide = false
	rightUpperLeg.Rotation = Vector3.new(-180, 0, -180)
	rightUpperLeg.Size = Vector3.new(1, 1.22, 1)
	rightUpperLeg.Parent = character

	local lowerTorso = Instance.new("MeshPart")
	lowerTorso.Name = "LowerTorso"
	lowerTorso.Anchored = true
	lowerTorso.CFrame = CFrame.new(-44.9217377, 3.50765204, 116.283035, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	lowerTorso.Rotation = Vector3.new(-180, 0, -180)
	lowerTorso.Size = Vector3.new(2, 0.4, 1)
	lowerTorso.Parent = character

	local morphBase = Instance.new("Humanoid")
	morphBase.Name = "MorphBase"
	morphBase.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	morphBase.HipHeight = 2
	morphBase.RigType = Enum.HumanoidRigType.R15
	morphBase.Parent = character

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Anchored = true
	head.BottomSurface = Enum.SurfaceType.Smooth
	head.CFrame = CFrame.new(-44.9217377, 5.80767918, 116.282761, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	head.Rotation = Vector3.new(-180, 0, -180)
	head.Size = Vector3.new(2, 1, 1)
	head.TopSurface = Enum.SurfaceType.Smooth

	local mesh = Instance.new("SpecialMesh")
	mesh.Name = "Mesh"
	mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
	mesh.Parent = head

	local face = Instance.new("Decal")
	face.Name = "face"
	face.Texture = "rbxasset://textures/face.png"
	face.Parent = head

	head.Parent = character

	character.Parent = morphyR15

	local leftHand1 = Instance.new("Folder")
	leftHand1.Name = "LeftHand"

	local middle = Instance.new("MeshPart")
	middle.Name = "Middle"
	middle.Anchored = true
	middle.CFrame = CFrame.new(-43.4214897, 3.45761704, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle.CanCollide = false
	middle.Rotation = Vector3.new(-180, 0, -180)
	middle.Size = Vector3.new(1, 0.3, 1)
	middle.Transparency = 1
	middle.Parent = leftHand1

	leftHand1.Parent = morphyR15

	local leftLowerArm1 = Instance.new("Folder")
	leftLowerArm1.Name = "LeftLowerArm"

	local middle1 = Instance.new("MeshPart")
	middle1.Name = "Middle"
	middle1.Anchored = true
	middle1.CFrame = CFrame.new(-43.4214897, 4.08359003, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle1.CanCollide = false
	middle1.Rotation = Vector3.new(-180, 0, -180)
	middle1.Size = Vector3.new(1, 1.05, 1)
	middle1.Transparency = 1
	middle1.Parent = leftLowerArm1

	leftLowerArm1.Parent = morphyR15

	local leftLowerLeg1 = Instance.new("Folder")
	leftLowerLeg1.Name = "LeftLowerLeg"

	local middle2 = Instance.new("MeshPart")
	middle2.Name = "Middle"
	middle2.Anchored = true
	middle2.CFrame = CFrame.new(-44.4214897, 2.10676003, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle2.CanCollide = false
	middle2.Rotation = Vector3.new(-180, 0, -180)
	middle2.Size = Vector3.new(1, 1.19, 1)
	middle2.Transparency = 1
	middle2.Parent = leftLowerLeg1

	leftLowerLeg1.Parent = morphyR15

	local leftUpperArm1 = Instance.new("Folder")
	leftUpperArm1.Name = "LeftUpperArm"

	local middle3 = Instance.new("MeshPart")
	middle3.Name = "Middle"
	middle3.Anchored = true
	middle3.CFrame = CFrame.new(-43.4214897, 4.67633581, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle3.CanCollide = false
	middle3.Rotation = Vector3.new(-180, 0, -180)
	middle3.Size = Vector3.new(1, 1.17, 1)
	middle3.Transparency = 1
	middle3.Parent = leftUpperArm1

	leftUpperArm1.Parent = morphyR15

	local leftUpperLeg1 = Instance.new("Folder")
	leftUpperLeg1.Name = "LeftUpperLeg"

	local middle4 = Instance.new("MeshPart")
	middle4.Name = "Middle"
	middle4.Anchored = true
	middle4.CFrame = CFrame.new(-44.4214897, 2.88688207, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle4.CanCollide = false
	middle4.Rotation = Vector3.new(-180, 0, -180)
	middle4.Size = Vector3.new(1, 1.22, 1)
	middle4.Transparency = 1
	middle4.Parent = leftUpperLeg1

	leftUpperLeg1.Parent = morphyR15

	local lowerTorso1 = Instance.new("Folder")
	lowerTorso1.Name = "LowerTorso"

	local middle5 = Instance.new("MeshPart")
	middle5.Name = "Middle"
	middle5.Anchored = true
	middle5.CFrame = CFrame.new(-44.9214897, 3.50763607, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle5.Rotation = Vector3.new(-180, 0, -180)
	middle5.Size = Vector3.new(2, 0.4, 1)
	middle5.Transparency = 1
	middle5.Parent = lowerTorso1

	lowerTorso1.Parent = morphyR15

	local rightFoot1 = Instance.new("Folder")
	rightFoot1.Name = "RightFoot"

	local middle6 = Instance.new("MeshPart")
	middle6.Name = "Middle"
	middle6.Anchored = true
	middle6.CFrame = CFrame.new(-45.4214897, 1.45766401, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle6.CanCollide = false
	middle6.Rotation = Vector3.new(-180, 0, -180)
	middle6.Size = Vector3.new(1, 0.3, 1)
	middle6.Transparency = 1
	middle6.Parent = rightFoot1

	rightFoot1.Parent = morphyR15

	local rightHand1 = Instance.new("Folder")
	rightHand1.Name = "RightHand"

	local middle7 = Instance.new("MeshPart")
	middle7.Name = "Middle"
	middle7.Anchored = true
	middle7.CFrame = CFrame.new(-46.4214897, 3.45761704, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle7.CanCollide = false
	middle7.Rotation = Vector3.new(-180, 0, -180)
	middle7.Size = Vector3.new(1, 0.3, 1)
	middle7.Transparency = 1
	middle7.Parent = rightHand1

	rightHand1.Parent = morphyR15

	local rightLowerArm1 = Instance.new("Folder")
	rightLowerArm1.Name = "RightLowerArm"

	local middle8 = Instance.new("MeshPart")
	middle8.Name = "Middle"
	middle8.Anchored = true
	middle8.CFrame = CFrame.new(-46.4214897, 4.08359003, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle8.CanCollide = false
	middle8.Rotation = Vector3.new(-180, 0, -180)
	middle8.Size = Vector3.new(1, 1.05, 1)
	middle8.Transparency = 1
	middle8.Parent = rightLowerArm1

	rightLowerArm1.Parent = morphyR15

	local rightLowerLeg1 = Instance.new("Folder")
	rightLowerLeg1.Name = "RightLowerLeg"

	local middle9 = Instance.new("MeshPart")
	middle9.Name = "Middle"
	middle9.Anchored = true
	middle9.CFrame = CFrame.new(-45.4214897, 2.10676003, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle9.CanCollide = false
	middle9.Rotation = Vector3.new(-180, 0, -180)
	middle9.Size = Vector3.new(1, 1.19, 1)
	middle9.Transparency = 1
	middle9.Parent = rightLowerLeg1

	rightLowerLeg1.Parent = morphyR15

	local rightUpperArm1 = Instance.new("Folder")
	rightUpperArm1.Name = "RightUpperArm"

	local middle10 = Instance.new("MeshPart")
	middle10.Name = "Middle"
	middle10.Anchored = true
	middle10.CFrame = CFrame.new(-46.4214897, 4.67633581, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle10.CanCollide = false
	middle10.Rotation = Vector3.new(-180, 0, -180)
	middle10.Size = Vector3.new(1, 1.17, 1)
	middle10.Transparency = 1
	middle10.Parent = rightUpperArm1

	rightUpperArm1.Parent = morphyR15

	local upperTorso1 = Instance.new("Folder")
	upperTorso1.Name = "UpperTorso"

	local middle11 = Instance.new("MeshPart")
	middle11.Name = "Middle"
	middle11.Anchored = true
	middle11.CFrame = CFrame.new(-44.9214897, 4.50764513, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle11.Rotation = Vector3.new(-180, 0, -180)
	middle11.Size = Vector3.new(2, 1.6, 1)
	middle11.Transparency = 1
	middle11.Parent = upperTorso1

	upperTorso1.Parent = morphyR15

	local head1 = Instance.new("Folder")
	head1.Name = "Head"

	local middle12 = Instance.new("Part")
	middle12.Name = "Middle"
	middle12.Anchored = true
	middle12.BottomSurface = Enum.SurfaceType.Smooth
	middle12.CFrame = CFrame.new(-44.9214897, 5.80766201, 116.282776, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle12.Rotation = Vector3.new(-180, 0, -180)
	middle12.Size = Vector3.new(2, 1, 1)
	middle12.TopSurface = Enum.SurfaceType.Smooth
	middle12.Transparency = 1
	middle12.Parent = head1

	head1.Parent = morphyR15

	local leftFoot1 = Instance.new("Folder")
	leftFoot1.Name = "LeftFoot"

	local middle13 = Instance.new("MeshPart")
	middle13.Name = "Middle"
	middle13.Anchored = true
	middle13.CFrame = CFrame.new(-44.4214897, 1.45766401, 116.283051, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle13.CanCollide = false
	middle13.Rotation = Vector3.new(-180, 0, -180)
	middle13.Size = Vector3.new(1, 0.3, 1)
	middle13.Transparency = 1
	middle13.Parent = leftFoot1

	leftFoot1.Parent = morphyR15

	local rightUpperLeg1 = Instance.new("Folder")
	rightUpperLeg1.Name = "RightUpperLeg"

	local middle14 = Instance.new("MeshPart")
	middle14.Name = "Middle"
	middle14.Anchored = true
	middle14.CFrame = CFrame.new(-45.4214897, 2.88688207, 116.283005, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	middle14.CanCollide = false
	middle14.Rotation = Vector3.new(-180, 0, -180)
	middle14.Size = Vector3.new(1, 1.22, 1)
	middle14.Transparency = 1
	middle14.Parent = rightUpperLeg1

	rightUpperLeg1.Parent = morphyR15
	
	morphyR15.Parent = uniforms
end

remote().Parent = game:GetService('ReplicatedStorage')
_script().Parent = game:GetService('ServerScriptService')
uniform().Parent = game:GetService('Workspace')
