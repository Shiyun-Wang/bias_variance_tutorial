# distribution of simulated sodium intake ---------------------------------
study |>
  ggplot()+ # remove everything inside
  geom_density(
    aes(x=truth), # move aes() inside each of geom_xxx
     colour = "blue", fill = "blue",
    alpha = 0.2) +
  geom_density(
    aes(x=recall),
    colour = "red",fill = "red", # have to write separate instructions for each measurement
    alpha = 0.2
  )+
  geom_density(
    aes(x=ffq),
    colour = "green",fill = "green",
    alpha = 0.2
  ) +
  geom_vline( # Removed aes() as we supply 3 calculated means directly, no need to use summarise(..., .by = measure) to calculate a separate mean for each category
    xintercept = c(
      mean(study$truth),
      mean(study$recall),
      mean(study$ffq)
    ),
    linetype = 2, linewidth = 1,
    show.legend = FALSE
  ) +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(
    x = "Sodium (mg/day)", 
    title = "Distribution of simulated sodium intake",
    subtitle = "Bias shifts the centre; variance widens the spread"
  ) +
  theme_minimal() +
  theme(
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    panel.border = element_rect(colour = "black", fill=NA)
  )

# lm lines ----------------------------------------------------------------
# facet_wrap(~measure, scales = "free_x")
study |>
  ggplot() +
  geom_point(aes(x=ffq, y=sbp), alpha = 0.2) +
  geom_point(aes(x=recall, y=sbp),alpha = 0.2) +
  geom_point(aes(x=truth, y=sbp), alpha = 0.2) +
  geom_smooth(aes(x = ffq, y = sbp),
              method = "lm", colour = "green") +
  geom_smooth(aes(x = recall, y = sbp),
              method = "lm", colour = "red") +
  geom_smooth(aes(x = truth, y = sbp),
              method = "lm", colour = "blue") +
  labs(
    x = "Sodium (mg/day)", 
    y = "SBP (mmHg)",
    title = "Fitted lines, SBP~sodium"
  ) +
  theme_minimal() +
  theme(
    panel.border = element_rect(colour = "black", fill=NA)
  )
# patchwork
library(patchwork)

p1 <- study |>
  ggplot(aes(x = truth, y = sbp)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Truth")

p2 <- study |>
  ggplot(aes(x = recall, y = sbp)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Recall")

p3 <- study |>
  ggplot(aes(x = ffq, y = sbp)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "FFQ")

(p1 + p2 + p3) &
  theme_minimal()
