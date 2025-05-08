local SetAATCosts = function ( self, controller, element )
	local controllerModel = Engine.GetModelForController( controller )
	local buttonListModel = self:getModel()
	local costModel = Engine.GetModel( buttonListModel, "cost" )
	local ownedModel = Engine.GetModel( buttonListModel, "owned" )
	local junkModel = Engine.GetModel( buttonListModel, "junk" )
	local cost = Engine.GetModelValue( costModel )
	local owned = Engine.GetModelValue( ownedModel )
	local junk = Engine.GetModelValue( junkModel )

	if cost ~= nil and owned ~= nil and junk ~= nil then
		if owned == true or cost < 0 then
			element:setText( Engine.Localize( "" ) )
		else
			element:setText( Engine.Localize( cost ) )
		end

		if cost > junk then
			element:setRGB( 0.71, 0.44, 0.47 )
		else
			element:setRGB( 0.78, 0.78, 0.78 )
		end
	end
end

local SetCostIcon = function ( self, controller, element )
	local buttonListModel = self:getModel()
	local costModel = Engine.GetModel( buttonListModel, "cost" )
	local ownedModel = Engine.GetModel( buttonListModel, "owned" )
	local cost = Engine.GetModelValue( costModel )
	local owned = Engine.GetModelValue( ownedModel )

	if cost ~= nil and owned ~= nil then
		if owned == true or cost < 0 then
			element:setImage( RegisterImage( "blacktransparent" ) )
		else
			element:setImage( RegisterImage( "ui_icons_zombie_squad_info_salvage" ) )
		end
	end
end

CoD.T10WeaponUpgradeButton1ListItem = InheritFrom( LUI.UIElement )
CoD.T10WeaponUpgradeButton1ListItem.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10WeaponUpgradeButton1ListItem )
	self.id = "T10WeaponUpgradeButton1ListItem"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 67 )
	self:setTopBottom( true, false, 0, 79.5 )
	self:makeFocusable()
	self:setHandleMouse( true )
	self.anyChildUsesUpdateState = true

	self.background = LUI.UIImage.new()
	self.background:setLeftRight( true, true, 0, 0 )
	self.background:setTopBottom( true, true, 0, 0 )
	self.background:setImage( RegisterImage( "ximage_bef1ea0fd3e274d" ) )
	self:addElement( self.background )

	self.focus1 = LUI.UIImage.new()
	self.focus1:setLeftRight( true, true, 0, 0 )
	self.focus1:setTopBottom( true, true, 0, 0 )
	self.focus1:setImage( RegisterImage( "ximage_2a964667b8907b8" ) )
	self:addElement( self.focus1 )

	self.focus2 = LUI.UIImage.new()
	self.focus2:setLeftRight( true, true, -3, 3 )
	self.focus2:setTopBottom( true, true, -3, 3 )
	self.focus2:setImage( RegisterImage( "ximage_66b56714699de1f" ) )
	self:addElement( self.focus2 )

	self.equippedbg = LUI.UIImage.new()
	self.equippedbg:setLeftRight( true, true, -1.25, 1.25 )
	self.equippedbg:setTopBottom( true, true, -15.5, 0 )
	self.equippedbg:setImage( RegisterImage( "blacktransparent" ) )
	self.equippedbg:linkToElementModel( self, "owned", true, function ( model )
		local owned = Engine.GetModelValue( model )

		if owned ~= nil then
			if owned == true then
				self.equippedbg:setImage( RegisterImage( "ximage_1ce8328d0e53675" ) )
			else
				self.equippedbg:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.equippedbg )

	self.equippedtext = LUI.UIText.new()
	self.equippedtext:setLeftRight( true, true, -100, 100 )
	self.equippedtext:setTopBottom( true, false, -20, 6 )
	self.equippedtext:setText( Engine.Localize( "EQUIPPED" ) )
	self.equippedtext:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.equippedtext:setRGB( 0.2, 0.2, 0.2 )
	self.equippedtext:setScale( 0.5 )
	self.equippedtext:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.equippedtext:linkToElementModel( self, "owned", true, function ( model )
		local owned = Engine.GetModelValue( model )

		if owned ~= nil then
			if owned == true then
				self.equippedtext:setText( Engine.Localize( "EQUIPPED" ) )
			else
				self.equippedtext:setText( Engine.Localize( "" ) )
			end
		end
	end )
	self:addElement( self.equippedtext )

	self.glow = LUI.UIImage.new()
	self.glow:setLeftRight( true, true, 0, 0 )
	self.glow:setTopBottom( true, true, 0, 0 )
	self.glow:setImage( RegisterImage( "blacktransparent" ) )
	self.glow:setAlpha( 0.3 )
	self.glow:linkToElementModel( self, "owned", true, function ( model )
		local owned = Engine.GetModelValue( model )

		if owned ~= nil then
			if owned == true then
				self.glow:setImage( RegisterImage( "ximage_770630ee8b9fb72" ) )
			else
				self.glow:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.glow )

	self.image = LUI.UIImage.new()
	self.image:setLeftRight( false, false, -26, 26.5 )
	self.image:setTopBottom( false, false, -29, 21.5 )
	self.image:setImage( RegisterImage( "blacktransparent" ) )
	self.image:linkToElementModel( self, "image", true, function ( model )
		local image = Engine.GetModelValue( model )

		if image then
			self.image:setImage( RegisterImage( image ) )
		end
	end )
	self:addElement( self.image )

	self.costicon = LUI.UIImage.new()
	self.costicon:setLeftRight( true, false, 11.5 + 1.5, 31.5 + 1.5 )
	self.costicon:setTopBottom( false, true, -20.5 + 0.5, -0.5 + 0.5 )
	self.costicon:setImage( RegisterImage( "blacktransparent" ) )
	self.costicon:linkToElementModel( self, "cost", true, function ( model )
		SetCostIcon( self, controller, self.costicon )
	end )
	self.costicon:linkToElementModel( self, "owned", true, function ( model )
		SetCostIcon( self, controller, self.costicon )
	end )
	self:addElement( self.costicon )

	self.cost = LUI.UIText.new()
	self.cost:setLeftRight( true, true, 21 + 2, 0 )
	self.cost:setTopBottom( true, true, 54 - 1, 8 + 1 )
	self.cost:setText( Engine.Localize( "" ) )
	self.cost:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.cost:setRGB( 0.78, 0.78, 0.78 )
	self.cost:setScale( 0.5 )
	self.cost:linkToElementModel( self, "cost", true, function ( model )
		SetAATCosts( self, controller, self.cost )
	end )
	self.cost:linkToElementModel( self, "owned", true, function ( model )
		SetAATCosts( self, controller, self.cost )
	end )
	self:addElement( self.cost )

	self.checkbox1 = LUI.UIImage.new()
	self.checkbox1:setLeftRight( false, true, -8.5 - 2, 0 - 2 )
	self.checkbox1:setTopBottom( true, false, 0 + 2, 8.5 + 2 )
	self.checkbox1:setImage( RegisterImage( "blacktransparent" ) )
	self.checkbox1:linkToElementModel( self, "owned", true, function ( model )
		local owned = Engine.GetModelValue( model )

		if owned ~= nil then
			if owned == true then
				self.checkbox1:setImage( RegisterImage( "ximage_3bf23945b721342" ) )
			else
				self.checkbox1:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.checkbox1 )
	
	self.checkbox2 = LUI.UIImage.new()
	self.checkbox2:setLeftRight( false, true, -8.5 - 2, 0 - 2 )
	self.checkbox2:setTopBottom( true, false, 0 + 2, 8.5 + 2 )
	self.checkbox2:setImage( RegisterImage( "blacktransparent" ) )
	self.checkbox2:setScale( 0.9 )
	self.checkbox2:linkToElementModel( self, "owned", true, function ( model )
		local owned = Engine.GetModelValue( model )

		if owned ~= nil then
			if owned == true then
				self.checkbox2:setImage( RegisterImage( "ximage_5f050b018d8a5d2" ) )
			else
				self.checkbox2:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.checkbox2 )

	self.weapontier = LUI.UIImage.new()
	self.weapontier:setLeftRight( true, true, -0.5, 0.5 )
	self.weapontier:setTopBottom( true, false, 0, 3.5 )
	self.weapontier:setImage( RegisterImage( "blacktransparent" ) )
	self.weapontier:linkToElementModel( self, "banner", true, function ( model )
		local banner = Engine.GetModelValue( model )

		if banner then
			self.weapontier:setImage( RegisterImage( banner ) )
		end
	end )
	self:addElement( self.weapontier )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )

				self.focus1:completeAnimation()
				self.focus1:setAlpha( 0 )
				self.clipFinished( self.focus1, {} )

				self.focus2:completeAnimation()
				self.focus2:setAlpha( 0 )
				self.clipFinished( self.focus2, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 2 )

				self.focus1:completeAnimation()
				self.focus1:setAlpha( 1 )
				self.clipFinished( self.focus1, {} )

				self.focus2:completeAnimation()
				self.focus2:setAlpha( 1 )
				self.clipFinished( self.focus2, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.background:close()
		element.focus1:close()
		element.focus2:close()
		element.equippedbg:close()
		element.equippedtext:close()
		element.glow:close()
		element.image:close()
		element.costicon:close()
		element.cost:close()
		element.checkbox1:close()
		element.checkbox2:close()
		element.weapontier:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
