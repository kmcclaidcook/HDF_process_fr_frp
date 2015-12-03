PRO Loop_MODIS_FRP_info_export_separate_20150911

CD, 'F:/Boundary_swaths'
fils=FILE_SEARCH('MOD021*.hdf')
n_fils=N_ELEMENTS(fils)-1

FOR i=0,n_fils DO BEGIN

	file_name=fils[i]
	tif_name=STRSPLIT(file_name,'.', /EXTRACT)
	sat=tif_name[0]
	sat=STRMID(sat,0,3)
	file_name03=FILE_SEARCH(sat+'03*'+STRJOIN(tif_name[1:3], '.')+'*')
	file_name03=file_name03[0]
	tif_name=STRJOIN(tif_name[0:3],'.')+'.'

	modis_level1b_read, file_name, 21, band21, /temperature
	modis_level1b_read, file_name, 22, band22, /temperature
	modis_level1b_read, file_name, 31, band31, /temperature
	modis_level1b_read, file_name, 32, band32, /temperature

	WRITE_TIFF, tif_name + 'BAND21.tif', band21, /FLOAT
	WRITE_TIFF, tif_name + 'BAND22.tif', band22, /FLOAT
	WRITE_TIFF, tif_name + 'BAND31.tif', band31, /FLOAT
	WRITE_TIFF, tif_name + 'BAND32.tif', band32, /FLOAT

	modis_level1b_read, file_name, 1, band1, /reflectance
	modis_level1b_read, file_name, 2, band2, /reflectance
	modis_level1b_read, file_name, 7, band7, /reflectance

	WRITE_TIFF, tif_name + 'BAND1.tif', band1, /FLOAT
	WRITE_TIFF, tif_name + 'BAND2.tif', band2, /FLOAT
	WRITE_TIFF, tif_name + 'BAND7.tif', band7, /FLOAT


	fileID = HDF_SD_Start(file_name03, /read)
	datafield_name='Land/SeaMask'
	dataset_index = HDF_SD_NameToIndex(fileID, datafield_name)
	datasetID = HDF_SD_Select(fileID, dataset_index)
	HDF_SD_GetData, datasetID, data_variable

	WRITE_TIFF, tif_name + 'LANDMASK.tif', data_variable, /FLOAT

	datafield_name='Latitude'
	dataset_index = HDF_SD_NameToIndex(fileID, datafield_name)
	datasetID = HDF_SD_Select(fileID, dataset_index)
	HDF_SD_GetData, datasetID, data_variable

	WRITE_TIFF, tif_name + 'LAT.tif', data_variable, /FLOAT

	datafield_name='Longitude'
	dataset_index = HDF_SD_NameToIndex(fileID, datafield_name)
	datasetID = HDF_SD_Select(fileID, dataset_index)
	HDF_SD_GetData, datasetID, data_variable
	WRITE_TIFF, tif_name + 'LON.tif', data_variable, /FLOAT
	
	datafield_name='SolarAzimuth'
	dataset_index = HDF_SD_NameToIndex(fileID, datafield_name)
	datasetID = HDF_SD_Select(fileID, dataset_index)
	HDF_SD_GetData, datasetID, data_variable
	WRITE_TIFF, tif_name + 'SolarAzimuth.tif', data_variable, /FLOAT
	
	datafield_name='SolarZenith'
	dataset_index = HDF_SD_NameToIndex(fileID, datafield_name)
	datasetID = HDF_SD_Select(fileID, dataset_index)
	HDF_SD_GetData, datasetID, data_variable
	WRITE_TIFF, tif_name + 'SolarZenith.tif', data_variable, /FLOAT

	datafield_name='SensorAzimuth'
	dataset_index = HDF_SD_NameToIndex(fileID, datafield_name)
	datasetID = HDF_SD_Select(fileID, dataset_index)
	HDF_SD_GetData, datasetID, data_variable
	WRITE_TIFF, tif_name + 'SensorAzimuth.tif', data_variable, /FLOAT
	
	ENDFOR


END

