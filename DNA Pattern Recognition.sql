SELECT
    sample_id,
    dna_sequence,
    species,
    CASE WHEN LEFT(dna_sequence, 3) = 'ATG' THEN 1 else 0 end has_start,
    CASE WHEN RIGHT(dna_sequence, 3) = 'TAA' THEN 1
         WHEN RIGHT(dna_sequence, 3) = 'TAG' THEN 1
         WHEN RIGHT(dna_sequence, 3) = 'TGA' THEN 1 
         else 0 end as has_stop,
    CASE WHEN dna_sequence LIKE '%ATAT%' THEN 1 else 0 end as has_atat,
    CASE WHEN dna_sequence REGEXP 'G{3,}' THEN 1 else 0 end as has_ggg
FROM
    Samples 
    