meta:
  id: nifti1
  file-extension: nii
  endian: le

seq:
  - id: header
    type: header
  - id: header_extension
    type: header_extension
  - id: data
    type: data
    
types:
  header:
    seq:
      - id: sizeof_hdr
        type: s4
        doc: "Must be 348."
      - id: data_type
        type: str
        size: 10
        encoding: UTF-8
        doc: "Unused."
      - id: db_name
        type: str
        size: 18
        encoding: UTF-8
        doc: "Unused."
      - id: extents
        type: s4
        doc: "Unused."
      - id: session_error
        type: s2
        doc: "Unused."
      - id: regular
        type: s1
        doc: "Unused."
      - id: dim_info
        type: s1
        enum: slice
        doc: "MRI slice ordering."
        
      - id: dim
        type: s2
        repeat: expr
        repeat-expr: 8
        doc: "Data array dimensions."
      - id: intent_p1
        type: f4
        doc: "1st intent parameter."
      - id: intent_p2
        type: f4
        doc: "2nd intent parameter."
      - id: intent_p3
        type: f4
        doc: "3rd intent parameter."
      - id: intent_code
        type: s2
        enum: intent
        doc: "NIFTI_INTENT_* code."
      - id: datatype
        type: s2
        enum: dt
        doc: "Defines data type."
      - id: bitpix
        type: s2
        doc: "Number bits/voxel."
      - id: slice_start
        type: s2
        doc: "First slice index."
      - id: pixdim
        type: f4
        repeat: expr
        repeat-expr: 8
        doc: "Grid spacings."
      - id: vox_offset
        type: f4
        doc: "Offset into .nii file"
      - id: scl_slope
        type: f4
        doc: "Data scaling: slope."
      - id: scl_inter
        type: f4
        doc: "Data scaling: offset."
      - id: slice_end
        type: s2
        doc: "Last slice index."
      - id: slice_code
        type: s1
        doc: "Slice timing order."
      - id: xyzt_units
        type: s1
        doc: "Units of pixdim[1..4]"
      - id: cal_max
        type: f4
        doc: "Max display intensity."
      - id: cal_min
        type: f4
        doc: "Min display intensity."
      - id: slice_duration
        type: f4
        doc: "Time for 1 slice."
      - id: toffset
        type: f4
        doc: "Time axis shift."
      - id: glmax
        type: s4
        doc: "Unused."
      - id: glmin
        type: s4
        doc: "Unused."
        
      - id: descrip
        type: str
        size: 80
        encoding: UTF-8
        doc: "Any text you like."
      - id: aux_file
        type: str
        size: 24
        encoding: UTF-8
        doc: "Auxiliary filename."
      
      - id: qform_code
        type: s2
        enum: xform
        doc: "NIFTI_XFORM_* code."
      - id: sform_code
        type: s2
        enum: xform
        doc: "NIFTI_XFORM_* code."
      
      - id: quatern_b
        type: f4
        doc: "Quaternion b param."
      - id: quatern_c
        type: f4
        doc: "Quaternion c param."
      - id: quatern_d
        type: f4
        doc: "Quaternion d param."
      - id: qoffset_x
        type: f4
        doc: "Quaternion x param."
      - id: qoffset_y
        type: f4
        doc: "Quaternion y param."
      - id: qoffset_z 
        type: f4
        doc: "Quaternion z param."
        
      - id: srow_x
        type: f4
        repeat: expr
        repeat-expr: 4
        doc: "1st row affine transform."
      - id: srow_y
        type: f4
        repeat: expr
        repeat-expr: 4
        doc: "2nd row affine transform."
      - id: srow_z
        type: f4
        repeat: expr
        repeat-expr: 4
        doc: "3rd row affine transform."
        
      - id: intent_name
        type: str
        size: 16
        encoding: UTF-8
        doc: "'name' or meaning of data."
      
      - id: magic
        type: str
        size: 4
        encoding: UTF-8
        doc: 'MUST be "ni1\0" or "n+1\0".'
        
    instances:
      spatial_units:
        value: xyzt_units & 0b111
        enum: units
      temporal_units:
        value: xyzt_units & 0b111000
        enum: units
        
  header_extension:
    seq:
      - id: extension
        type: str
        size: 4
        encoding: UTF-8
        doc: "TODO."
        
  data:
    seq:
      - id: data
        size-eos: true
      
enums:
  dt:
    0: unknown
    1: binary
    2: uint8
    4: int16
    8: int32
    16: float32
    32: complex64
    64: float64
    128: rgb24
    256: int8
    512: unit16
    768: uint32
    1024: int64
    1280: uint64
    1536: float128
    1792: complex128
    2048: complex256
    2304: rgba32
    
  intent:
    0: none
    2: correl
    3: ttest
    4: ftest
    5: zscore
    6: chisq
    7: beta
    8: binom
    9: gamma
    10: poisson
    11: normal
    12: ftest_nonc
    13: chisq_nonc
    14: logistic
    15: laplace
    16: uniform
    17: ttest_nonc
    18: weibull
    19: chi
    20: invgauss
    21: extval
    22: pval
    23: logpval
    24: log10pval
    1001: estimate
    1002: label
    1003: neuroname
    1004: genmatrix
    1005: symmatrix
    1006: dispvect
    1007: vector
    1008: pointset
    1009: triangle
    1010: quaternion
    1011: dimless
    2001: time_series
    2002: node_index
    2003: rgb_vector
    2004: rgba_vector
    2005: shape
    2006: fsl_fnirt_displacement_field
    2007: fsl_cubic_spline_coefficients
    2008: fsl_dct_coefficients
    2009: fsl_quadratic_spline_coefficients
    2016: fsl_topup_cubic_spline_coefficients
    2017: fsl_topup_quadratic_spline_coefficients
    2018: fsl_topup_field
    
  xform:
    0: unknown
    1: scanner_anat
    2: aligned_anat
    3: talairach
    4: mni_152
    5: template_other
    
  units:
    0: unknown
    1: meter
    2: mm
    3: micron
    8: sec
    16: msec
    24: usec
    32: hz
    40: ppm
    48: rads
    
  slice:
    0: unknown
    1: seq_inc
    2: seq_dec
    3: alt_inc
    4: alt_dec
    5: alt_inc2
    6: alt_dec2
    
       