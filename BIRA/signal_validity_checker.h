#ifndef __SIGNALVALIDITYCHECKER_H
#define __SIGNALVALIDITYCHECKER_H
#include "spare_struct.h"
#include "singal_generator.h"
#include "CAM.h"

extern int pivot_block[PCAM_SIZE];
extern int must_repair[PCAM_SIZE];
extern bool uncover_must_pivot[PCAM_SIZE];
extern bool unused_spare[R_SPARE + C_SPARE];


// if DSSS and RLSS is valid -> True
// valid : 1) Signal covered all must repair fault line, 2) Spares at block doesn't exceed the allocated number of spares  
bool signal_valid() {
	int cnt_col[2] = { 0 };
	int cnt_row[2] = { 0 };
	int rlss_idx = 0;
	int wide_idx = -1;
	// bool temp = 0;
	bool fail = 0;
	bool spare_fail = false; // added
	memset(unused_spare, true, sizeof(unused_spare));
	memset(uncover_must_pivot, false, sizeof(uncover_must_pivot));

	// 1 stage
	for (int i = 0; i <= pcamCnt; i++) {       // check whether must_repair is covered.
		if (DSSS[i] == ROW) {
			if (RLSS[rlss_idx++])
				wide_idx = i;
		}
		fail = false;
		if (must_repair[i]) {
			switch (must_repair[i]) {
				// row must repair
			case 0x4:
				if (DSSS[i] != ROW) {
					fail = true;
					uncover_must_pivot[i] = true;
					continue;
				}
				switch (STRUCT_TYPE) {
					// spare structure 1 with row must flag
				case S1:
					if (pivot_block[i] == 1) {
						if (unused_spare[0])
							unused_spare[0] = false;
						else if (unused_spare[2])
							unused_spare[2] = false;
						else
							fail = true;
					}
					else if (pivot_block[i] == 2) {
						if (unused_spare[1])
							unused_spare[1] = false;
						else if (unused_spare[3])
							unused_spare[3] = false;
						else
							fail = true;
					}
					break;
					// spare structure 2 with row must flag
				case S2:
					if (pivot_block[i] == 1) {
						if (unused_spare[0])
							unused_spare[0] = false;
						else if (unused_spare[2])
							unused_spare[2] = false;
						else
							fail = true;
					}
					else if (pivot_block[i] == 2) {
						if (unused_spare[1])
							unused_spare[1] = false;
						else if (unused_spare[3])
							unused_spare[3] = false;
						else
							fail = true;
					}
					break;
					// spare structure 3 with row must flag
				case S3:
					if (pivot_block[i] == 1) {
						if (unused_spare[0])
							unused_spare[0] = false;
						else if (unused_spare[2]) {       // row must flag 일 때 row spare가 부족하면 global spare 사용해야 하는지?
							unused_spare[2] = false;
							unused_spare[3] = false;
						}
						else
							fail = true;
					}
					else if (pivot_block[i] == 2) {
						if (unused_spare[1])
							unused_spare[1] = false;
						else if (unused_spare[2]) {
							unused_spare[2] = false;
							unused_spare[3] = false;
						}
						else
							fail = true;
					}
					break;
				default:
					break;
				}
				break;
				// col must repair
			case 0x2:
				if (DSSS[i] != COL) {
					fail = true;
					uncover_must_pivot[i] = true;
					continue;
				}
				switch (STRUCT_TYPE) {
					// spare structure 1 with col must flag
				case S1:
					if (pivot_block[i] == 1) {
						if (unused_spare[4])
							unused_spare[4] = false;
						else if (unused_spare[6])
							unused_spare[6] = false;
						else
							fail = true;
					}
					else if (pivot_block[i] == 2) {
						if (unused_spare[5])
							unused_spare[5] = false;
						else if (unused_spare[7])
							unused_spare[7] = false;
						else
							fail = true;
					}
					break;
					// spare structure 2 with col must flag
				case S2:
					if (unused_spare[6] || unused_spare[7]) { // common spare has a higher priority
						if (unused_spare[6])
							unused_spare[6] = false;
						else if (unused_spare[7])
							unused_spare[7] = false;
					}
					else if (pivot_block[i] == 1) {
						if (unused_spare[4])
							unused_spare[4] = false;
						else
							fail = true;
					}
					if (unused_spare[6] || unused_spare[7]) { // common spare has a higher priority
						if (unused_spare[6])
							unused_spare[6] = false;
						else if (unused_spare[7])
							unused_spare[7] = false;
					}
					else if (pivot_block[i] == 2) {
						if (unused_spare[5])
							unused_spare[5] = false;
						else
							fail = true;
					}
					break;
					// spare structure 3 with col must flag
				case S3:
					if (unused_spare[6] || unused_spare[7]) { // common spare has a higher priority
						if (unused_spare[6])
							unused_spare[6] = false;
						else if (unused_spare[7])
							unused_spare[7] = false;
					}
					else if (pivot_block[i] == 1) {
						if (unused_spare[4])
							unused_spare[4] = false;
						else
							fail = true;
					}
					if (unused_spare[6] || unused_spare[7]) { // common spare has a higher priority
						if (unused_spare[6])
							unused_spare[6] = false;
						else if (unused_spare[7])
							unused_spare[7] = false;
					}
					else if (pivot_block[i] == 2) {
						if (unused_spare[5])
							unused_spare[5] = false;
						else
							fail = true;
					}
					break;
				default:
					break;
				}
				break;
				// row adjacent must flag
			case 0x1:	// adj must, adjacent must일 경우, RLSS는 무조건 1이 되어야 하는가?
				if ((DSSS[i] != ROW) || (wide_idx != i)) {
					fail = true;
					uncover_must_pivot[i] = true;
					continue;
				}
				switch (STRUCT_TYPE) {
				case S1:
				case S2:
					fail = true; // case S1, S2 don't have global spare
					break;
					// spare structure 3 with row adjacent must flag
				case S3:
					if (unused_spare[2] && (wide_idx == i)) { // global spare has a higher priority
						unused_spare[2] = false;
						unused_spare[3] = false;
					}
					else
						fail = true;
					break;
				default:
					break;
				}
				break;
			default:
				break;
			}
		}
		if (fail)
			uncover_must_pivot[i] = true;
	}
	// initialize variables
	rlss_idx = 0;
	memset(unused_spare, true, sizeof(unused_spare));
	// 2 stage
	for (int i = 0; i <= pcamCnt; i++) {                // find unused spare
		if (DSSS[i] == ROW) {
			if (RLSS[rlss_idx++])
				wide_idx = i;
			switch (STRUCT_TYPE) {
			case S1:
				if (pivot_block[i] == 1) {
					if (unused_spare[0])
						unused_spare[0] = false;
					else if (unused_spare[2])
						unused_spare[2] = false;
					else
						spare_fail = true;
				}
				else if (pivot_block[i] == 2) {
					if (unused_spare[1])
						unused_spare[1] = false;
					else if (unused_spare[3])
						unused_spare[3] = false;
					else
						spare_fail = true;
				}
				break;
			case S2:
				if (pivot_block[i] == 1) {
					if (unused_spare[0])
						unused_spare[0] = false;
					else if (unused_spare[2])
						unused_spare[2] = false;
					else
						spare_fail = true;
				}
				else if (pivot_block[i] == 2) {
					if (unused_spare[1])
						unused_spare[1] = false;
					else if (unused_spare[3])
						unused_spare[3] = false;
					else
						spare_fail = true;
				}
				break;
			case S3:
				if (pivot_block[i] == 1) {
					if (unused_spare[2] && (wide_idx == i)) {  // global spare has a higher priority
						unused_spare[2] = false;
						unused_spare[3] = false;               // global spare : 2bit size
					}
					else if (unused_spare[0])
						unused_spare[0] = false;
					else
						spare_fail = true;
				}
				else if (pivot_block[i] == 2) {
					if (unused_spare[2] && (wide_idx == i)) {
						unused_spare[2] = false;
						unused_spare[3] = false;
					}
					else if (unused_spare[1])
						unused_spare[1] = false;
					else
						spare_fail = true;
				}
				break;
			}
		}
		if (DSSS[i] == COL) {
			switch (STRUCT_TYPE) {
			case S1:
				if (pivot_block[i] == 1) {
					if (unused_spare[4])
						unused_spare[4] = false;
					else if (unused_spare[6])
						unused_spare[6] = false;
					else
						spare_fail = true;
				}
				else if (pivot_block[i] == 2) {
					if (unused_spare[5])
						unused_spare[5] = false;
					else if (unused_spare[7])
						unused_spare[7] = false;
					else
						spare_fail = true;
				}
				break;
			case S2:
				if (unused_spare[6] || unused_spare[7]) {          // common spare has a higher priority
					if (unused_spare[6])
						unused_spare[6] = false;
					else if (unused_spare[7])
						unused_spare[7] = false;
				}
				else if (pivot_block[i] == 1) {
					if (unused_spare[4])
						unused_spare[4] = false;
					else
						spare_fail = true;
				}
				else if (pivot_block[i] == 2) {
					if (unused_spare[5])
						unused_spare[5] = false;
					else
						spare_fail = true;
				}
				break;
			case S3:
				if (unused_spare[6] || unused_spare[7]) {          // common spare has a higher priority
					if (unused_spare[6])
						unused_spare[6] = false;
					else if (unused_spare[7])
						unused_spare[7] = false;
				}
				else if (pivot_block[i] == 1) {
					if (unused_spare[4])
						unused_spare[4] = false;
					else
						spare_fail = true;
				}
				else if (pivot_block[i] == 2) {
					if (unused_spare[5])
						unused_spare[5] = false;
					else
						spare_fail = true;
				}
				break;
			}
		}
	} // end of finding unused spare
	if (spare_fail)
		return false;	// if spare cannot be assigned, signal valid is 0
	return true;
	}
#endif // !__SIGNALVALIDITYCHECKER_H