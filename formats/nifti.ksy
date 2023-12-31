meta:
  id: nifti
  title: Neuroimaging Informatics Technology Initiative (NIfTI) data format
  file-extension: nii
  endian: be
doc-ref: "https://nifti.nimh.nih.gov/nifti-1"
doc: |
  This spec captures both version 1.1 and 2 of the Neuroimaging Informatics 
  Technology Initiative (NIfTI) data format.

seq:
  - id: sizeof_hdr_preflight
    doc: |
      The first 4 bytes can be read to determine both if its nifti version 1.1
      or version 2 and the endianness of the file.
    size: 4

instances:
  file:
    pos: 0
    type:
      switch-on: sizeof_hdr_preflight
      cases:
        "[0x5c, 0x01, 0x00, 0x00]": n1_file
        "[0x00, 0x00, 0x01, 0x5c]": n1_file
        "[0x1c, 0x02, 0x00, 0x00]": n2_file
        "[0x00, 0x00, 0x02, 0x1c]": n2_file

types:
  n1_file:
    meta:
      endian:
        switch-on: _root.sizeof_hdr_preflight
        cases:
          "[0x5c, 0x01, 0x00, 0x00]": le
          "[0x00, 0x00, 0x01, 0x5c]": be
    seq:
      - id: header
        type: header
      - id: extension_indicator
        type: extension_indicator
      - id: extension
        type: extension
        if: extension_indicator.has_extension == 1
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
            doc: "Unused placeholder for ANALYZE(TM) 7.5 backwards compatibility. (Removed in NIfTI-2)."
          - id: db_name
            type: str
            size: 18
            encoding: UTF-8
            doc: "Unused placeholder for ANALYZE(TM) 7.5 backwards compatibility. (Removed in NIfTI-2)."
          - id: extents
            type: s4
            doc: "Unused placeholder for ANALYZE(TM) 7.5 backwards compatibility. (Removed in NIfTI-2)."
          - id: session_error
            type: s2
            doc: "Unused placeholder for ANALYZE(TM) 7.5 backwards compatibility. (Removed in NIfTI-2)."
          - id: regular
            type: s1
            doc: "Unused placeholder for ANALYZE(TM) 7.5 backwards compatibility. (Removed in NIfTI-2)."
          - id: dim_info
            type: s1
            doc: "MRI slice ordering. Stores frequency_dim, phase_dim and slice_dim in 2 bit each."

          - id: dim
            type: s2
            repeat: expr
            repeat-expr: 8
            doc: "Data array dimensions. dim[0] contains the number of dimensions, dim[1..7] describe the sizes of the dimensions."
          - id: intent_p1
            type: f4
            doc: "1st intent parameter. Contains additionaly parameters depending on the intent code."
          - id: intent_p2
            type: f4
            doc: "2nd intent parameter. Contains additionaly parameters depending on the intent code."
          - id: intent_p3
            type: f4
            doc: "3rd intent parameter. Contains additionaly parameters depending on the intent code."
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
            enum: slice
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
            doc: 'MUST be "ni1\\0" or "n+1\\0".'

        instances:
          frequency_dim:
            value: dim_info & 0b11
          phase_dim:
            value: dim_info >> 2 & 0b11
          slice_dim:
            value: dim_info >> 4 & 0b11
          spatial_units:
            value: xyzt_units & 0b111
            enum: units
          temporal_units:
            value: xyzt_units & 0b111000
            enum: units

      extension_indicator:
        seq:
          - id: has_extension
            type: s1
          - id: padding
            size: 3

      extension:
        seq:
          - id: extension_header
            type: extension_header
          - id: extension_data
            type: extension_data

        types:
          extension_header:
            seq:
              - id: esize
                type: s4
              - id: ecode
                enum: ecode
                type: s4

          extension_data:
            seq:
              - id: edata
                type: str
                size: _parent.extension_header.esize - 8
                encoding: UTF-8

      data:
        seq:
          - id: data
            size: |
              (_parent.header.bitpix / 8) *
              (_parent.header.dim[0] >= 1 ? _parent.header.dim[1] : 1) *
              (_parent.header.dim[0] >= 2 ? _parent.header.dim[2] : 1) *
              (_parent.header.dim[0] >= 3 ? _parent.header.dim[3] : 1) *
              (_parent.header.dim[0] >= 4 ? _parent.header.dim[4] : 1) *
              (_parent.header.dim[0] >= 5 ? _parent.header.dim[5] : 1) *
              (_parent.header.dim[0] >= 6 ? _parent.header.dim[6] : 1) *
              (_parent.header.dim[0] >= 7 ? _parent.header.dim[7] : 1)

  n2_file:
    meta:
      endian:
        switch-on: _root.sizeof_hdr_preflight
        cases:
          "[0x1c, 0x02, 0x00, 0x00]": le
          "[0x00, 0x00, 0x02, 0x1c]": be
    seq:
      - id: header
        type: header
      - id: extension_indicator
        type: extension_indicator
      - id: extension
        type: extension
        if: extension_indicator.has_extension == 1
      - id: data
        type: data

    types:
      header:
        seq:
          - id: sizeof_hdr
            type: s4
            doc: "Must be 540."
          - id: magic
            type: str
            size: 4
            encoding: UTF-8
            doc: "MUST be 'ni2\\0' or 'n+2\\0'."
          - id: magic2
            type: s1
            repeat: expr
            repeat-expr: 4
            doc: "MUST be 0D 0A 1A 0A."
          - id: datatype
            type: s2
            enum: dt
            doc: "Defines data type."
          - id: bitpix
            type: s2
            doc: "Number bits/voxel."
          - id: dim
            type: s8
            repeat: expr
            repeat-expr: 8
            doc: "Data array dimensions."
          - id: intent_p1
            type: f8
            doc: "1st intent parameter."
          - id: intent_p2
            type: f8
            doc: "2nd intent parameter."
          - id: intent_p3
            type: f8
            doc: "3rd intent parameter."
          - id: pixdim
            type: f8
            repeat: expr
            repeat-expr: 8
            doc: "Grid spacings."
          - id: vox_offset
            type: s8
            doc: "Offset into .nii file"
          - id: scl_slope
            type: f8
            doc: "Data scaling: slope."
          - id: scl_inter
            type: f8
            doc: "Data scaling: offset."
          - id: cal_max
            type: f8
            doc: "Max display intensity."
          - id: cal_min
            type: f8
            doc: "Min display intensity."
          - id: slice_duration
            type: f8
            doc: "Time for 1 slice."
          - id: toffset
            type: f8
            doc: "Time axis shift."
          - id: slice_start
            type: s8
            doc: "First slice index."
          - id: slice_end
            type: s8
            doc: "Last slice index."

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
            type: s4
            enum: xform
            doc: "NIFTI_XFORM_* code."
          - id: sform_code
            type: s4
            enum: xform
            doc: "NIFTI_XFORM_* code."

          - id: quatern_b
            type: f8
            doc: "Quaternion b param."
          - id: quatern_c
            type: f8
            doc: "Quaternion c param."
          - id: quatern_d
            type: f8
            doc: "Quaternion d param."
          - id: qoffset_x
            type: f8
            doc: "Quaternion x param."
          - id: qoffset_y
            type: f8
            doc: "Quaternion y param."
          - id: qoffset_z
            type: f8
            doc: "Quaternion z param."

          - id: srow_x
            type: f8
            repeat: expr
            repeat-expr: 4
            doc: "1st row affine transform."
          - id: srow_y
            type: f8
            repeat: expr
            repeat-expr: 4
            doc: "2nd row affine transform."
          - id: srow_z
            type: f8
            repeat: expr
            repeat-expr: 4
            doc: "3rd row affine transform."

          - id: slice_code
            type: s4
            enum: slice
            doc: "Slice timing order."
          - id: xyzt_units
            type: s4
            doc: "Units of pixdim[1..4]"
          - id: intent_code
            type: s4
            enum: intent
            doc: "NIFTI_INTENT_* code."
          - id: intent_name
            type: str
            size: 16
            encoding: UTF-8
            doc: "'name' or meaning of data."

          - id: dim_info
            type: s1
            doc: "MRI slice ordering."

          - id: unused_str
            type: str
            size: 15
            encoding: UTF-8
            doc: "unused, filled with \\0"

        instances:
          frequency_dim:
            value: dim_info & 0b11
          phase_dim:
            value: dim_info >> 2 & 0b11
          slice_dim:
            value: dim_info >> 4 & 0b11
          spatial_units:
            value: xyzt_units & 0b111
            enum: units
          temporal_units:
            value: xyzt_units & 0b111000
            enum: units

      extension_indicator:
        seq:
          - id: has_extension
            type: s1
          - id: padding
            size: 3

      extension:
        seq:
          - id: extension_header
            type: extension_header
          - id: extension_data
            type: extension_data

        types:
          extension_header:
            seq:
              - id: esize
                type: s4
              - id: ecode
                enum: ecode
                type: s4

          extension_data:
            seq:
              - id: edata
                type: str
                size: _parent.extension_header.esize - 8
                encoding: UTF-8

      data:
        seq:
          - id: data
            size: |
              (_parent.header.bitpix / 8) *
              (_parent.header.dim[0] >= 1 ? _parent.header.dim[1] : 1) *
              (_parent.header.dim[0] >= 2 ? _parent.header.dim[2] : 1) *
              (_parent.header.dim[0] >= 3 ? _parent.header.dim[3] : 1) *
              (_parent.header.dim[0] >= 4 ? _parent.header.dim[4] : 1) *
              (_parent.header.dim[0] >= 5 ? _parent.header.dim[5] : 1) *
              (_parent.header.dim[0] >= 6 ? _parent.header.dim[6] : 1) *
              (_parent.header.dim[0] >= 7 ? _parent.header.dim[7] : 1)

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
    512: uint16
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
    0:
      id: unknown
      doc: "Arbitrary coordinates."
    1:
      id: scanner_anat
      doc: "Scanner-based anatomical coordinates."
    2:
      id: aligned_anat
      doc: 'Coordinates aligned to another file''s, or to the anatomical "truth" (with an arbitrary coordinate center).'
    3:
      id: talairach
      doc: "Coordinates aligned to the Talairach space."
    4:
      id: mni_152
      doc: "Coordinates aligned to the MNI152 space."
    5:
      id: template_other
      doc: "Coordinates aligned to some template that is not MNI152 or Talairach."

  units:
    0:
      id: unknown
      doc: "Unknown units"
    1:
      id: meter
      doc: "Meter (m)"
    2:
      id: mm
      doc: "Millimeter (mm)"
    3:
      id: micron
      doc: "Micron (um)"
    8:
      id: sec
      doc: "Seconds (s)"
    16:
      id: msec
      doc: "Miliseconds (ms)"
    24:
      id: usec
      doc: "Microseconds (us)"
    32:
      id: hz
      doc: "Hertz (Hz)"
    40:
      id: ppm
      doc: "Parts-per-million (ppm)"
    48:
      id: rads
      doc: "Radians per second (rad/s)"

  slice:
    0:
      id: unknown
      doc: "Slice order: Unknown"
    1:
      id: seq_inc
      doc: "Slice order: Sequential, increasing"
    2:
      id: seq_dec
      doc: "Slice order: Sequential, decreasing"
    3:
      id: alt_inc
      doc: "Slice order: Interleaved, increasing, starting at the first slice"
    4:
      id: alt_dec
      doc: "Slice order: Interleaved, decreasing, starting at the last slice"
    5:
      id: alt_inc2
      doc: "Slice order: Interleaved, increasing, starting at the second slice"
    6:
      id: alt_dec2
      doc: "Slice order: Interleaved, decreasing, starting at the second to last slice"

  ecode:
    0: ignore
    2:
      id: dicom
      doc: "intended for raw DICOM attributes"
    4:
      id: afni
      doc: |
        Robert W Cox: rwcox@nih.gov
        https://afni.nimh.nih.gov/afni
    6:
      id: comment
      doc: "plain ASCII text only"
    8:
      id: xcede
      doc: |
        David B Keator: dbkeator@uci.edu
        http://www.nbirn.net/Resources/Users/Applications/xcede/index.htm
    10:
      id: jimdiminfo
      doc: |
        Mark A Horsfield
        mah5@leicester.ac.uk
    12:
      id: workflow_fwds
      doc: |
        Kate Fissell: fissell@pitt.edu
        http://kraepelin.wpic.pitt.edu/~fissell/NIFTI_ECODE_WORKFLOW_FWDS/NIFTI_ECODE_WORKFLOW_FWDS.html
    14:
      id: freesurfer
      doc: "http://surfer.nmr.mgh.harvard.edu/"
    16:
      id: pypickle
      doc: "embedded Python objects"
    18:
      id: mind_ident
      doc: |
        LONI MiND codes: http://www.loni.ucla.edu/twiki/bin/view/Main/MiND
        Vishal Patel: vishal.patel@ucla.edu
    20:
      id: b_value
      doc: |
        LONI MiND codes: http://www.loni.ucla.edu/twiki/bin/view/Main/MiND
        Vishal Patel: vishal.patel@ucla.edu
    22:
      id: spherical_direction
      doc: |
        LONI MiND codes: http://www.loni.ucla.edu/twiki/bin/view/Main/MiND
        Vishal Patel: vishal.patel@ucla.edu
    24:
      id: dt_component
      doc: |
        LONI MiND codes: http://www.loni.ucla.edu/twiki/bin/view/Main/MiND
        Vishal Patel: vishal.patel@ucla.edu
    26:
      id: shc_degreeorder
      doc: |
        LONI MiND codes: http://www.loni.ucla.edu/twiki/bin/view/Main/MiND
        Vishal Patel: vishal.patel@ucla.edu
    28:
      id: voxbo
      doc: "Dan Kimberg: www.voxbo.org"
    30:
      id: caret
      doc: |
        John Harwell: john@brainvis.wustl.edu
        http://brainvis.wustl.edu/wiki/index.php/Caret:Documentation:CaretNiftiExtension
    32:
      id: cifti
      doc: CIFTI-2_Main_FINAL_1March2014.pdf
    34: variable_frame_timing
    38:
      id: eval
      doc: "Munster University Hospital"
    40:
      id: matlab
      doc: |
        MATLAB extension
        http://www.mathworks.com/matlabcentral/fileexchange/42997-dicom-to-nifti-converter
    42:
      id: quantiphyse
      doc: |
        Quantiphyse extension
        https://quantiphyse.readthedocs.io/en/latest/advanced/nifti_extension.html
    44:
      id: mrs
      doc: |
        Magnetic Resonance Spectroscopy (MRS)
