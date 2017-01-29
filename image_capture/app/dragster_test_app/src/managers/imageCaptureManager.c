#include "imageCaptureManager.h"

#define SPI_DEVICE_ID XPAR_SPI_0_DEVICE_ID
#define IMAGE_CAPTURE_MANAGER_BASE_ADDRESS 0x43C00000

void ImageCaptureManager::initialize()
{
	initializeSpi();
}

void ImageCaptureManager::startImageCapture()
{
	Xil_Out32(IMAGE_CAPTURE_MANAGER_BASE_ADDRESS, 1);
	xil_printf("\n Image Capture Manager has been started\n\r");
}

void ImageCaptureManager::stopImageCapture()
{
	Xil_Out32(IMAGE_CAPTURE_MANAGER_BASE_ADDRESS, 2);
	xil_printf("\n Image Capture Manager has been stopped\n\r");
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

	/* �� ��������� SPI �������� Slave, ����� ���� ������������� ��� ��� Master */
	/* status = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION);
	if(Status != XST_SUCCESS) {
		xil_printf("\n XSpi_SetOptions Failed\n\r"); */

	/* ��������� SPI */
	XSpi_Start(&_spi);

	/* ������������ SPI ���������� */
	XSpi_IntrGlobalDisable(&_spi);
}

