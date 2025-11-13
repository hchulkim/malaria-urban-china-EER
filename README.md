# Replication repository information

This is a GitHub repository for replicating *"Malaria suitability, urbanization and persistence: Evidence from China over more than 2000 years (European Economic Review)"* at UKRN Replication Games. 

## Authors

[Marc Joëts](https://www.marcjoets.com/)

[Hyoungchul Kim](https://hchulkim.github.io/)

[Stefania Lovo](https://sites.google.com/site/stefanialovo/)

[Niklas Murken](https://www.rwi-essen.de/rwi/team/person/niklas-murken)

## Citation

If you want to cite our replication results or reports, please use this `bibtex` citation

```
@article{JoetsKimLovoMurken2025,
  title        = {A Comment on “Malaria Suitability, Urbanization and Persistence: Evidence from China over More than 2000 Years”},
  author       = {Marc Joëts and Hyoungchul Kim and Stefania Lovo and Niklas Murken},
  year         = {2025},
  month        = {November},
  institution  = {UKRN Replication Games, Institute for Replication},
  note         = {Replication report},
}
```

## File structure

- `code/`: This folder contains code scripts used to creates replication results in the report. It also contains two original `Stata` do files (`EER-D-16-00243_Main.do` and `EER-D-16-00243_Appendix.do`) of the original authors.
- `data/raw/`: This folder contains original data provided by the original authors.
- `original-scripts/`: This folder contains a zip file of the replication package provided by the `European Economic Review`.
- `output/tables/`: This folder contains tables used in the replication report.
- `output/figures/`: This folder contains figures used in the replication report.
- `output/paper/`: This folder contains replication report.

## Replication instructions

### Stata

For `Stata`, manually execute the scripts in the `code/` folder. Since `Stata` is a licensed program, it should generally run without issues on other computers. However, you must have a valid license to use it.

### R

>If you want, you can use `nix` and `rix` for reproducibility. If you don't know what `nix` and/or `rix` is, check it out here: [LINK](https://docs.ropensci.org/rix/index.html). You can use the provided `Makefile` to run all the `R` codes in `nix/rix`.

If you don't want to or don't know about `nix/rix`, you can also just manually run the `R` scripts in the `code/` folder.

