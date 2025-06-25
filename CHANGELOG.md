**Version 0.5.4**
- Integer caster should only allow integer range by default (-2^31, 2^31)

**Version 0.5.3**
- Added optional support for array and string size validation

**Version 0.5.2**
- Rename AttributesCaster to HashCast::RecursiveCasterApplicator, to highlight that it's not a regular Caster

**Version 0.5.1**
- String caster should validate for null byte by default
- skip_unexpected_attributes option is true by default