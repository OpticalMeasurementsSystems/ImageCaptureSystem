#include "imageCaptureManager.h"

#define SPI_DEVICE_ID XPAR_SPI_0_DEVICE_ID

void ImageCaptureManager::initialize()
{
	initializeSpi();
}

void ImageCaptureManager::startImageCapture()
{

}

void ImageCaptureManager::stopImageCapture()
{

}

/* ������������� SPI � ����������� ������ (polling mode)*/
void ImageCaptureManager::initializeSpi()
{
	int status;

	/* ����������� ������������ ���������� */
	XSpi_Config* spiConfig = XSpi_LookupConfig(SPI_DEVICE_ID);
	if(!spiConfig)
		xil_printf("\n XSpi_LookupConfig Failed\n\r");

	/* �������������� ��������� SPI */
	status = XSpi_CfgInitialize(&_spi, spiConfig, spiConfig->BaseAddress);
	if(status != XST_SUCCESS)
		xil_printf("\n XSpi_CfgInitialize Failed\n\r");

	/* �� ��������� SPI �������� Slave, ����� ���� ������������� ��� ��� Master
	/* status = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION);
	if(Status != XST_SUCCESS) {
		xil_printf("\n XSpi_SetOptions Failed\n\r"); */

	/* ��������� SPI */
	XSpi_Start(&_spi);

	/* ������������ SPI ���������� */
	XSpi_IntrGlobalDisable(&_spi);
}


