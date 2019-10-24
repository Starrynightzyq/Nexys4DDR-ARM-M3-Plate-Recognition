/******************************************************************************
 * @file AXI_DPTI.c
 * AXI DPTI driver.
 *
 * @author Sergiu Arpadi
 *
 * @date 2016-Sep-20
 *
 * @copyright
 * (c) 2016 Copyright Digilent Incorporated
 * All Rights Reserved
 *
 * This program is free software; distributed under the terms of BSD 3-clause
 * license ("Revised BSD License", "New BSD License", or "Modified BSD License")
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
 *    of its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 * @desciption
 * Contains AXI DPTI transfer request function.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who            Date         Changes
 * ----- -------------- ------------ -----------------------------------------------
 * 1.00  Sergiu Arpadi  2016-Sep-20  First release
 *
 * </pre>
 *
 *****************************************************************************/

/***************************** Include Files *******************************/
#include "AXI_DPTI.h"
#include "xil_io.h"

/************************** Function Definitions ***************************/
XStatus DPTI_SimpleTransfer (u32 BaseAddress, u8 Direction, u32 TransferLength)
{
	u32 flag_0, flag_16, StsReg;

	if (TransferLength <0 || TransferLength > 8388607)
		return XST_FAILURE; // length is not a valid number
	else
	{
		StsReg = Xil_In32 (BaseAddress + STATUS_REG_OFFSET);
		flag_0 = (StsReg & 0x01);
		flag_16 = (StsReg >> 0x10 ) & 0x01;

		while (flag_16 == 0 || flag_0 == 0)
			{
				StsReg = Xil_In32 (BaseAddress + STATUS_REG_OFFSET);
				flag_0 = (StsReg & 0x01);
				flag_16 = (StsReg >> 0x10 ) & 0x01;
			}

		if (flag_16 == 1 && flag_0 == 1)
			{
				if (Direction == 1)
						Xil_Out32(BaseAddress + CONTROL_REG_OFFSET, STREAM_TO_DPTI);

				if (Direction == 2)
						Xil_Out32(BaseAddress + CONTROL_REG_OFFSET, DPTI_TO_STREAM);

				Xil_Out32 (BaseAddress + LENGTH_REG_OFFSET, TransferLength);
			}

	}

	return XST_SUCCESS;

}
