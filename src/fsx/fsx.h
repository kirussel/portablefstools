/*
 * Copyright 2015 Google Inc.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */

#ifdef __APPLE__
#include <sys/xattr.h>
#include <sys/paths.h>
#define fsx_caching_on(_fd) (fcntl(_fd, F_NOCACHE, 0))
#define fsx_caching_off(_fd) (fcntl(_fd, F_NOCACHE, 1))
#else /* __APPLE__ */
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <unistd.h>
#ifdef _PC_XATTR_SIZE_BITS
#include <sys/xattr.h>
#else /* _PC_XATTR_SIZE_BIT */
int fgetxattr(int, const char*, void*, size_t, uint32_t, int);
int fsetxattr(int, const char*, void*, size_t, uint32_t, int);
int fremovexattr(int, const char*, int);
#define fremovexattr(_a, _b, _c) (errno = ENOSYS, (int)-1)
#define fsetxattr(_a, _b, _c, _d, _e, _f) (errno = ENOSYS, (int)-1)
#define fgetxattr(_a, _b, _c, _d, _e, _f) (errno = ENOSYS, (int)-1)
#endif /* _PC_XATTR_SIZE_BIT */

#ifndef _PATH_FORKSPECIFIER
#define _PATH_FORKSPECIFIER "."
#endif

#ifdef POSIX_FADV_WILLNEED
#define fsx_caching_on(_fd) (posix_fadvise(fd, 0, 0, POSIX_FADV_WILLNEED))
#else
#define fsx_caching_on(_fd) (errno = ENOSYS, (int)-1)
#endif

#ifdef POSIX_FADV_DONTNEED
#define fsx_caching_off(_fd) (posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED))
#else
#define fsx_caching_off(_fd) (errno = ENOSYS, (int)-1)
#endif
#endif /* __APPLE__ */
