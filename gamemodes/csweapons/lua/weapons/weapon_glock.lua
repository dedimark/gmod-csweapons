AddCSLuaFile()
DEFINE_BASECLASS( "weapon_csbasegun" )

CSParseWeaponInfo( SWEP , [[WeaponData
{
	"MaxPlayerSpeed"		"250"
	"WeaponType"			"Pistol"
	"FullAuto"				0
	"WeaponPrice"			"400"
	"WeaponArmorRatio"		"1.05"
	"CrosshairMinDistance"		"8"
	"CrosshairDeltaDistance"	"3"
	"Team" 				"ANY"
	"BuiltRightHanded"		"0"
	"PlayerAnimationExtension" 	"pistol"
	"MuzzleFlashScale"		"1.0"
	
	"CanEquipWithShield"		"1"


	// Weapon characteristics:
	"Penetration"			"1"
	"Damage"			"25"
	"Range"				"4096"
	"RangeModifier"			"0.75"
	"Bullets"			"1"
	"CycleTime"			"0.15"
	
	// New accuracy model parameters
	"Spread"					0.00400
	"InaccuracyCrouch"			0.00750
	"InaccuracyStand"			0.01000
	"InaccuracyJump"			0.27750
	"InaccuracyLand"			0.05550
	"InaccuracyLadder"			0.01850
	"InaccuracyFire"			0.03167
	"InaccuracyMove"			0.01665
								
	"SpreadAlt"					0.00400
	"InaccuracyCrouchAlt"		0.00750
	"InaccuracyStandAlt"		0.01000
	"InaccuracyJumpAlt"			0.27750
	"InaccuracyLandAlt"			0.05550
	"InaccuracyLadderAlt"		0.01850
	"InaccuracyFireAlt"			0.02217
	"InaccuracyMoveAlt"			0.01665
								 
	"RecoveryTimeCrouch"		0.21875
	"RecoveryTimeStand"			0.26249
	
	// Weapon data is loaded by both the Game and Client DLLs.
	"printname"			"#Cstrike_WPNHUD_Glock18"
	"viewmodel"			"models/weapons/v_pist_glock18.mdl"
	"playermodel"			"models/weapons/w_pist_glock18.mdl"
	"shieldviewmodel"		"models/weapons/v_shield_glock18_r.mdl"	
	"anim_prefix"			"anim"
	"bucket"			"1"
	"bucket_position"		"1"

	"clip_size"			"20"
	
	"primary_ammo"			"BULLET_PLAYER_9MM"
	"secondary_ammo"		"None"

	"weight"			"5"
	"item_flags"			"0"

	// Sounds for the weapon. There is a max of 16 sounds per category (i.e. max 16 "single_shot" sounds)
	SoundData
	{
		//"reload"			"Default.Reload"
		//"empty"				"Default.ClipEmpty_Rifle"
		"single_shot"		"Weapon_Glock.Single"
	}

	// Weapon Sprite data is loaded by the Client DLL.
	TextureData
	{
		"weapon"
		{
				"font"		"CSweaponsSmall"
				"character"	"C"
		}
		"weapon_s"
		{	
				"font"		"CSweapons"
				"character"	"C"
		}
		"ammo"
		{
				"font"		"CSTypeDeath"
				"character"		"R"
		}
		"crosshair"
		{
				"file"		"sprites/crosshairs"
				"x"			"0"
				"y"			"48"
				"width"		"24"
				"height"	"24"
		}
		"autoaim"
		{
				"file"		"sprites/crosshairs"
				"x"			"0"
				"y"			"48"
				"width"		"24"
				"height"	"24"
		}
	}
	ModelBounds
	{
		Viewmodel
		{
			Mins	"-8 -4 -14"
			Maxs	"17 9 -1"
		}
		World
		{
			Mins	"-1 -3 -3"
			Maxs	"11 4 4"
		}
	}
}]] )

SWEP.Spawnable = true

function SWEP:Initialize()
	BaseClass.Initialize( self )
	self:SetHoldType( "pistol" )
	self:SetBurstFireEnabled( false )
	self:SetMaxBurstFires( 3 )
	self:SetBurstFireDelay( 0.1 )
	self:SetWeaponID( CS_WEAPON_GLOCK )
end

function SWEP:Deploy()
	
	self:SetAccuracy( 0.9 )
	
	return BaseClass.Deploy( self )
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryAttack() > CurTime() then return end
	
	if self:GetBurstFireEnabled() then
		--[[if not self:GetOwner():OnGround() then
			self:GunFire( 1.2 * ( 1- self:GetAccuracy()), true )
		elseif self:GetOwner():GetAbsVelocity():Length2D() > 5 then
			self:GunFire( 0.185 * ( 1- self:GetAccuracy()), true )
		elseif self:GetOwner():Crouching() then
			self:GunFire( 0.095 * ( 1- self:GetAccuracy()), true )
		else
			self:GunFire( 0.3 * ( 1- self:GetAccuracy()), true )
		end
		]]
		self:GunFire( 0.05 , false )	--thanks valve!
	else
		if not self:GetOwner():OnGround() then
			self:GunFire( 1.0 * ( 1- self:GetAccuracy()), true )
		elseif self:GetOwner():GetAbsVelocity():Length2D() > 5 then
			self:GunFire( 0.165 * ( 1- self:GetAccuracy()), true )
		elseif self:GetOwner():Crouching() then
			self:GunFire( 0.075 * ( 1- self:GetAccuracy()), true )
		else
			self:GunFire( 0.1 * ( 1- self:GetAccuracy()), true )
		end
	end
end

function SWEP:TranslateViewModelActivity( act )
	if self:GetBurstFireEnabled() and act == ACT_VM_PRIMARYATTACK then
		return ACT_VM_SECONDARYATTACK
	else
		return BaseClass.TranslateViewModelActivity( self , act )
	end
end

function SWEP:GunFire( spread , mode )
	
	self:SetAccuracy( self:GetAccuracy() - 0.275 * ( 0.325 - CurTime() - self:GetLastFire() ) )

	if self:GetAccuracy() > 0.9 then
		self:SetAccuracy( 0.9 )
	elseif self:GetAccuracy() < 0.6 then
		self:SetAccuracy( 0.6 )
	end
	
	self:BaseGunFire( spread, self:GetWeaponInfo().CycleTime, mode  )
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryAttack() > CurTime() then return end
	
	self:ToggleBurstFire()
	self:SetNextSecondaryAttack( CurTime() + 0.3 )
end