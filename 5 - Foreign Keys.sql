use PROJETO
-- Foreign Keys:

alter table AccountRecoverySystem add constraint AccountRecoverySystem_FK_Questions
foreign key (AccRS_question) references Questions(Ques_questionKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table AccountRecoverySystem add constraint AccountRecoverySystem_FK_USERS
foreign key (AccRS_UserID) references USERS(U_userID)
ON DELETE NO ACTION ON UPDATE NO ACTION;

/*alter table sentEmails add constraint sentEmails_FK_USERS
foreign key (senE_EmailsAdress) references USERS(U_emailAdress)
ON DELETE CASCADE ON UPDATE CASCADE;*/

alter table ERRORLOG add constraint ERRORLOG_FK_ERROR
foreign key (ERL_ErrorID) references ERROR(ER_ErrorID)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table StateLocation add constraint StateLocation_FK_CountryName
foreign key (StaL_countryRegionCode) references CountryName(CouN_countryRegionCode)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table State_City add constraint State_City_FK_StateLocation
foreign key (StaC_stateProvinceKey) references StateLocation(StaL_stateProvinceKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table State_City add constraint CityLocation_FK_State_City
foreign key (StaC_cityKey) references CityLocation(CitL_cityKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Customer add constraint Customer_FK_CityLocation
foreign key (Cus_cityKey) references CityLocation(CitL_cityKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Customer add constraint Customer_FK_RelationshipInformation
foreign key (Cus_relationshipKey) references RelationshipInformation(Rel_relationshipKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Customer add constraint Customer_FK_CustomerPossessions
foreign key (Cus_possessionsKey) references CustomerPossessions(CusP_possessionsKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Product add constraint Product_FK_ProductColor
foreign key (Pro_colorKey) references ProductColor(ProC_colorKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Product add constraint Product_FK_SizeDetails
foreign key (Pro_SizeDetailsKey) references SizeDetails(SizD_SizeDetailsKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Product add constraint Product_FK_MiscellaneousProductInfo
foreign key (Pro_MiscellaneousProductInfoKey) references MiscellaneousProductInfo(Mis_productDescriptionKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Product add constraint Product_FK_WeightDetails
foreign key (Pro_WeightDetailsKey) references WeightDetails(WeiD_WeightDetailsKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Product add constraint Product_FK_ProductLanguageCategory
foreign key (Pro_productLanguageCategoryKey) references ProductLanguageCategory(ProLC_productLanguageKey)
ON DELETE CASCADE ON UPDATE CASCADE;

alter table ProductLanguageCategory add constraint ProductLanguageCategory_FK_ProductSubCategory
foreign key (ProLC_productSubCategorykey) references ProductSubCategory(ProSB_productSubCategorykey)
ON DELETE CASCADE ON UPDATE CASCADE;

alter table Product add constraint Product_FK_ProductDescription
foreign key (Pro_productDescriptionKey) references ProductDescription(ProDe_productDescriptionKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table Product add constraint Product_FK_ProductModelName
foreign key (Pro_modelKey) references ProductModelName(ProDN_ModelKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table SalesOrderDetails add constraint SalesOrderDetails_FK_Product
foreign key (SalOD_productKey) references Product(Pro_productKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table SalesOrder add constraint SalesOrder_FK_SalesTerritory
foreign key (SalO_salesTerritoryKey) references SalesTerritory(salT_SalesTerritoryKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table SalesOrder add constraint SalesOrder_FK_Customer
foreign key (SalO_customerKey) references Customer(Cus_customerKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table SalesOrder add constraint SalesOrder_FK_Company
foreign key (SalO_companyKey) references Company(Com_companyKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table SalesOrder add constraint SalesOrder_FK_Currency
foreign key (SalO_currencyKey) references Currency(Cur_CurrencyKey)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table SalesOrderDetails add constraint SalesOrderDetails_FK_SalesOrder
foreign key (SalOD_SalesOrderKey) references SalesOrder(SalO_SalesOrderkey)
ON DELETE NO ACTION ON UPDATE NO ACTION;